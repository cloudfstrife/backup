#!/bin/bash

# -------------------------------------------------------------------------------
# TOOLS_LIST_FILE_NAME 包含工具列表的CSV文件
# -------------------------------------------------------------------------------
TOOLS_LIST_FILE_NAME=./all_tools_information.csv

# -------------------------------------------------------------------------------
# git项目URL后缀
# -------------------------------------------------------------------------------
GIT_PREFIX="https://"

# -------------------------------------------------------------------------------
# git项目URL后缀
# -------------------------------------------------------------------------------
GIT_POSTFIX=".git"

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
        log "ERROR" "$2"
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
    git checkout -q $3
    showError $? "Switch to $3 branch"
    git pull -q $GIT_ALICE_NAME $3
    showError $? "Pulling code from remote git branch $3"
    log "INFO" "DONE PULL $1"
}

# -------------------------------------------------------------------------------
# 克隆（拉取）git 项目指定分支到指定目录
# github https://github.com/golang/tools.git "$GOPATH/src/golang.org/x/tools" master
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

gobuild(){
	if [ ! -d "$1" ]; then
		showError "1" "Folder [$GOPATH/src/$1] Not exists"
	fi
	
	log "INFO" "START BUILD $2"
	cd "$1"
	go install $3
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
    if [ -z "$GOROOT" ] ;then
        showError "1" "Environment variables [GOROOT] NOT set"
    fi

    if [ ! -f "$GOROOT/bin/go" ] ;then
        showError "1" "Environment variables [GOROOT] NOT a go install PATH"
    fi

    if [ -z "$GOPATH" ] ;then
        showError "1" "Environment variables [GOPATH] NOT set"
    fi
	
	# 
	go env -w GOPROXY=https://goproxy.cn,direct
	go env -w GOSUMDB=sum.golang.google.cn
	
    rm -rf $GOPATH/bin/*
	go clean -modcache
    rm -rf $GOPATH/pkg/*
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
		target_folder="$GOPATH/src/$folder"
		
		printf "\n\u001b[31m                            %s                            \u001b[0m\n" "$tool_name"
		
		github "$GIT_PREFIX$github$GIT_POSTFIX" "$target_folder" "master"
		gobuild "$target_folder" "$tool_name" "$build"
	done
}

# -------------------------------------------------------------------------------
# begin
# -------------------------------------------------------------------------------
prepare

main

ending