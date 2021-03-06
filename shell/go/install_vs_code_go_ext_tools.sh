#!/bin/bash

#  ******************************************************************************
#  Linux 安装 Visual Studio Code 的go语言插件扩展工具的shell
#  
#  ****    脚本前置条件    ****
#  * 安装好Go环境 version >= 1.13
#  * 安装好git
#  * 配置GOPATH
#  ******************************************************************************

# -------------------------------------------------------------------------------
# TOOLS_LIST_FILE_NAME 包含工具列表的CSV文件
# -------------------------------------------------------------------------------
TOOLS_LIST_FILE_NAME=`pwd`/all_tools_information.csv

# -------------------------------------------------------------------------------
# git项目URL后缀
# -------------------------------------------------------------------------------
GIT_PREFIX="https://"

# -------------------------------------------------------------------------------
# git项目URL后缀
# -------------------------------------------------------------------------------
GIT_POSTFIX=".git"

# -------------------------------------------------------------------------------
# 安装目录
# -------------------------------------------------------------------------------
INSTALL_PATH=""

# -------------------------------------------------------------------------------
# 日志输出
# 参数1 日志级别
# 参数2 日志内容
# -------------------------------------------------------------------------------
log(){
    printf "%s [ %-7s ] : %s\n" "$(date '+%F %T')" "$1" "$2"
}

# -------------------------------------------------------------------------------
# 处理错误
# 参数1 上一命令返回状态，一般为$?
# 参数2 任务说明
# -------------------------------------------------------------------------------
showError(){
    if [ $1 != "0" ]; then
        printf "\u001b[31m %s [ %-7s ] : %s \u001b[0m\n" "$(date '+%F %T')" "ERROR" "$2"
        exit 1
    fi 
}

# -------------------------------------------------------------------------------
#  克隆项目指定分支到目录
#  参数1 git地址
#  参数2 目录
#  参数3 分支
# -------------------------------------------------------------------------------
github_clone(){
    log "INFO" "START CLONE $1"
    git clone -q $1 $2
    showError $? "CLONE $1"
    cd $2
    git checkout -q $3
    showError $? "CHECKOUT $1 TO $3 branch"
    log "INFO" "DONE CLONE $1"
}

# -------------------------------------------------------------------------------
#  拉取项目的指定分支
#  参数1 git地址
#  参数2 项目所在目录
#  参数3 分支
# -------------------------------------------------------------------------------
github_checkout(){
    cd $2
    if [ ! -d "$2/.git" ]; then
        showError "1" "target folder is not a git project folder"
    fi
    GIT_ALICE_NAME="$(git remote show)"
    GIT_REMOTE_URL="$(git remote get-url --all $GIT_ALICE_NAME)"

    if [ "$1" != "$GIT_REMOTE_URL"  ]; then
        showError "1" "git remote url do not match"
    fi

    log "INFO" "START PULL $1"
    git checkout -- .
    git checkout -q $3
    showError $? "Switch to $3 branch"
    git pull -q $GIT_ALICE_NAME $3
    showError $? "Pulling code from remote git branch $3"
    log "INFO" "DONE PULL $1"
}

# -------------------------------------------------------------------------------
# 克隆（拉取）git 项目指定分支到指定目录
#  参数1 git地址
#  参数2 项目所在目录
#  参数3 分支
# -------------------------------------------------------------------------------
github(){
    if [ -z "$3" ] ; then
        showError "1" "github function invoked without enough parameter"
    fi

    if [ ! -d $2 ]; then
        github_clone $1 $2 $3
    else
        github_checkout $1 $2 $3
    fi
}

# -------------------------------------------------------------------------------
#  构建Go程序
#  参数1 程序源代码所在目录
#  参数2 程序名称
#  参数3 go install 指令参数
# -------------------------------------------------------------------------------
gobuild(){
    if [ ! -d "$1" ]; then
        showError "1" "Folder [ $1 ] Not exists"
    fi
    
    log "INFO" "START BUILD $2"
    cd "$1"
    
    # 计算字符串长度，计算'-gomod'字符的偏移值与长度
    LENGTH=$(echo "$2" | wc -m)
    OFFSET=$(expr $LENGTH - 1 - 6)
    MAX=$(expr $LENGTH - 1)
    
    if [ ${2:OFFSET:MAX} = "-gomod"  ] ; then
        go build -o $INSTALL_PATH/bin/$2
        showError $? "BUILD $2"
    else
        go install $3
        showError $? "BUILD $2"
    fi
    
    showError $? "BUILD $2"
    log "INFO" "DONE BUILD $2"
}


# -------------------------------------------------------------------------------
# 准备
# 1> 检查Go环境变量设置是否正确
# 2> 设置 go module proxy 
# 3> 清除$GOPATH/bin 和 go module 缓存
# -------------------------------------------------------------------------------
prepare(){
    # 检查环境变量
    if [ -z "$GOROOT" ] ;then
        showError "1" "Environment variables [GOROOT] NOT set"
    fi

    if [ ! -f "$GOROOT/bin/go" ] ;then
        showError "1" "Environment variables [GOROOT] NOT a go install PATH"
    fi

    if [ -z "$GOPATH" ] ;then
        showError "1" "Environment variables [GOPATH] NOT set"
    fi
	
	# 初始化安装目录
	INSTALL_PATH=${GOPATH%:*}
	
	printf "########################################################################\n"
	printf "## GOPATH : $GOPATH \n"
	printf "## Install To $INSTALL_PATH \n"
	printf "########################################################################\n"
	
    # 设置代理和验证服务器
    go env -w GOPROXY=https://goproxy.cn,direct
    go env -w GOSUMDB=sum.golang.google.cn
    
    # 清理模块缓存 
    rm -rf $INSTALL_PATH/bin/*
    go clean -modcache

    # 拉取golang.org的库，解决非go module模式的扩展工具的依赖问题
    github "$GIT_PREFIX""github.com/golang/build""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/build" master
    github "$GIT_PREFIX""github.com/golang/crypto""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/crypto" master
    github "$GIT_PREFIX""github.com/golang/xerrors""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/xerrors" master
    github "$GIT_PREFIX""github.com/golang/exp""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/exp" master
    github "$GIT_PREFIX""github.com/golang/image""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/image" master
    github "$GIT_PREFIX""github.com/golang/lint""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/lint" master
    github "$GIT_PREFIX""github.com/golang/mobile""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/mobile" master
    github "$GIT_PREFIX""github.com/golang/mod""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/mod" master
    github "$GIT_PREFIX""github.com/golang/net""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/net" master
    github "$GIT_PREFIX""github.com/golang/oauth2""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/oauth2" master
    github "$GIT_PREFIX""github.com/golang/perf""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/perf" master
    github "$GIT_PREFIX""github.com/golang/review""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/review" master
    github "$GIT_PREFIX""github.com/golang/sync""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/sync" master
    github "$GIT_PREFIX""github.com/golang/sys""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/sys" master
    github "$GIT_PREFIX""github.com/golang/text""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/text" master
    github "$GIT_PREFIX""github.com/golang/tools""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/tools" master
    github "$GIT_PREFIX""github.com/golang/time""$GIT_POSTFIX" "$INSTALL_PATH/src/golang.org/x/time" master
    github "$GIT_PREFIX""github.com/skratchdot/open-golang""$GIT_POSTFIX"  "$INSTALL_PATH/src/github.com/skratchdot/open-golang" master
}

# -------------------------------------------------------------------------------
# 重置 go module proxy 设置
# -------------------------------------------------------------------------------
ending(){
    go env -u GOPROXY
    go env -u GOSUMDB
}

main(){
    line=0
    for l in `cat $TOOLS_LIST_FILE_NAME` 
    do
        line=`expr $line + 1`
        if [ "$line" == "1" ]; then
            continue
        fi
        
        tool_name=`echo $l | awk -F ',' '{print $1}'`
        github=`echo $l | awk -F ',' '{print $2}'`
        folder=`echo $l | awk -F ',' '{print $3}'`
        build=`echo $l | awk -F ',' '{print $4}'`
		install_cmd=`echo $l | awk -F ',' '{print $5}'`
        
		target_folder="$INSTALL_PATH/src/$folder"
        
		printf "########################################################################\n"
        printf "##                               %s\n" "$tool_name"
        printf "########################################################################\n"
		
        github "$GIT_PREFIX$github$GIT_POSTFIX" "$target_folder" "master"
        gobuild "$INSTALL_PATH/src/$build" "$tool_name" "$install_cmd"
    done
}

# -------------------------------------------------------------------------------
# begin
# -------------------------------------------------------------------------------
prepare

main

ending