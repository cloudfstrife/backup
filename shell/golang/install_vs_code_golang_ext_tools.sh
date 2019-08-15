#!/bin/bash

#  ******************************************************************************
#  Linux安装 Visual Studio Code 的go语言插件扩展工具的shell
#  
#  ****    脚本前置条件    ****
#  * 安装好Go环境
#  * 配置好GOPATH环境变量，目前只支持一个目录
#  * 安装好git
#  
#  ****    脚本后置操作    ****
#  sudo cp $GOPATH/bin/* $GOROOT/bin
#  gometalinter --install
#  ******************************************************************************

# *******************************************************************************
# https://github.com/Microsoft/vscode-go/blob/master/src/goInstallTools.ts
# *******************************************************************************
# 'gocode': 'github.com/mdempsky/gocode',
# 'gocode-gomod': 'github.com/stamblerre/gocode',
# 'gopkgs': 'github.com/uudashr/gopkgs/cmd/gopkgs',
# 'go-outline': 'github.com/ramya-rao-a/go-outline',
# 'go-symbols': 'github.com/acroca/go-symbols',
# 'guru': 'golang.org/x/tools/cmd/guru',
# 'gorename': 'golang.org/x/tools/cmd/gorename',
# 'gomodifytags': 'github.com/fatih/gomodifytags',
# 'goplay': 'github.com/haya14busa/goplay/cmd/goplay',
# 'impl': 'github.com/josharian/impl',
# 'gotype-live': 'github.com/tylerb/gotype-live',
# 'godef': 'github.com/rogpeppe/godef',
# 'gogetdoc': 'github.com/zmb3/gogetdoc',
# 'goimports': 'golang.org/x/tools/cmd/goimports',
# 'goreturns': 'github.com/sqs/goreturns',
# 'goformat': 'winterdrache.de/goformat/goformat',
# 'golint': 'golang.org/x/lint/golint',
# 'gotests': 'github.com/cweill/gotests/...',
# 'gometalinter': 'github.com/alecthomas/gometalinter',
# 'staticcheck': 'honnef.co/go/tools/...',
# 'golangci-lint': 'github.com/golangci/golangci-lint/cmd/golangci-lint',
# 'revive': 'github.com/mgechev/revive',
# 'go-langserver': 'github.com/sourcegraph/go-langserver',
# 'gopls': 'golang.org/x/tools/cmd/gopls',
# 'dlv': 'github.com/go-delve/delve/cmd/dlv',
# 'fillstruct': 'github.com/davidrjenni/reftools/cmd/fillstruct',
# 'godoctor': 'github.com/godoctor/godoctor',
#  ******************************************************************************

# git项目URL后缀
GIT_POSTFIX=".git"
# git项目URL后缀
GIT_PREFIX="https://"
# build函数中去除的部分
REMOVE="/..."

# -------------------------------------------------------------------------------
#  处理错误
#  参数1 上一命令返回状态，一般为$?
#  参数2 任务说明
# -------------------------------------------------------------------------------
showError(){
    if [ $1 != "0" ]; then
        log "ERROR" "$2"
        exit 1
    fi 
}

# -------------------------------------------------------------------------------
#  日志输出
#  参数1 日志级别
#  参数2 日志内容
# -------------------------------------------------------------------------------
log(){
    printf "%s [ %-7s ] : %s\n" "$(date '+%F %T')" "$1" "$2"
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
        log "START" "CLONE $1"
        git clone -q $1 $2
        showError $? "CLONE $1"
        cd $2
        git checkout -q $3
        showError $? "CHECKOUT $1 TO $3 branch"
        log "DONE" "CLONE $1"
    else
        cd $2
        if [ ! -d "$2/.git" ]; then
            showError "1" "target folder is not a git project folder"
        fi
        GIT_ALICE_NAME="$(git remote show)"
        GIT_REMOTE_URL="$(git remote get-url --all $GIT_ALICE_NAME)"

        if [ "$1" != "$GIT_REMOTE_URL"  ]; then
            showError "1" "git remote url do not match"
        fi

        log "START" "PULL $1"
        git checkout -q $3
        showError $? "Switch to $3 branch"
        git pull -q $GIT_ALICE_NAME $3
        showError $? "Pulling code from remote git branch $3"
        log "DONE" "PULL $1"
    fi
}

# -------------------------------------------------------------------------------
# 检查Go环境变量设置是否正确
# -------------------------------------------------------------------------------
check_go_env(){
    if [ -z "$GOROOT" ] ;then
        showError "1" "Environment variables [GOROOT] NOT set"
    fi

    if [ ! -f "$GOROOT/bin/go" ] ;then
        showError "1" "Environment variables [GOROOT] NOT a go install PATH"
    fi

    if [ -z "$GOPATH" ] ;then
        showError "1" "Environment variables [GOPATH] NOT set"
    fi    
}

# -------------------------------------------------------------------------------
# 删除 $GOPATH/bin 目录和 $GOPATH/bin 目录下的文件
# 清理 go build的缓存
# -------------------------------------------------------------------------------
clean_go_env(){
    rm -rf $GOPATH/bin/*
    rm -rf $GOPATH/pkg/*
    go clean 
    go clean -cache
}

# -------------------------------------------------------------------------------
# 构建 go 扩展依赖工具
# 参数一：git仓库地址
# 参数二：工具名称
# 参数二：go install 的URL
# 示例：
# build https://github.com/mdempsky/gocode.git gocode github.com/mdempsky/gocode
# -------------------------------------------------------------------------------
build(){
    if [ -z "$3" ] ; then
        showError "1" "build function invoked without enough parameter"
    fi

    log "START" "BUILD $2"
    
    # 计算字符串长度，计算'-gomod'字符的偏移值与长度
    LENGTH=$(echo "$2" | wc -m)
    OFFSET=$(expr $LENGTH - 1 - 6)
    MAX=$(expr $LENGTH - 1)

    TARGET_FOLDER=${1##$GIT_PREFIX}
    TARGET_FOLDER=${TARGET_FOLDER%%$GIT_POSTFIX}
    
    github $1 $GOPATH/src/$TARGET_FOLDER master
    if [ ${2:OFFSET:MAX} = "-gomod"  ] ; then
        go build -o $GOPATH/bin/$2 $3
        showError $? "BUILD $2"
    else
        go install $3
        showError $? "BUILD $2"
    fi
    log "DONE" "BUILD $2"
    echo ""
}

# -------------------------------------------------------------------------------
# 环境变量检查
# -------------------------------------------------------------------------------
check_go_env

clean_go_env

# -------------------------------------------------------------------------------
# golang
# -------------------------------------------------------------------------------
log "START" "FETCH golang build-in tools"
echo ""

github https://github.com/golang/tools.git "$GOPATH/src/golang.org/x/tools" master
echo ""

github https://github.com/golang/mobile.git "$GOPATH/src/golang.org/x/mobile" master
echo ""

github https://github.com/golang/net.git "$GOPATH/src/golang.org/x/net" master
echo ""

github https://github.com/golang/crypto.git "$GOPATH/src/golang.org/x/crypto" master
echo ""

github https://github.com/golang/exp.git "$GOPATH/src/golang.org/x/exp" master
echo ""

github https://github.com/golang/vgo.git "$GOPATH/src/golang.org/x/vgo" master
echo ""

github https://github.com/golang/sys.git "$GOPATH/src/golang.org/x/sys" master
echo ""

github https://github.com/golang/text.git "$GOPATH/src/golang.org/x/text" master
echo ""

github https://github.com/golang/lint.git "$GOPATH/src/golang.org/x/lint" master
echo ""

github https://github.com/golang/image.git "$GOPATH/src/golang.org/x/image" master
echo ""

github https://github.com/golang/time.git "$GOPATH/src/golang.org/x/time" master
echo ""

github https://github.com/golang/sync.git "$GOPATH/src/golang.org/x/sync" master
echo ""

github https://github.com/golang/mod.git "$GOPATH/src/golang.org/x/mod" master
echo ""

log "DONE" "FETCH golang build-in tools"
echo ""

# -------------------------------------------------------------------------------
# guru
# -------------------------------------------------------------------------------
log "START" "BUILD guru"
go install golang.org/x/tools/cmd/guru
showError $? "BUILD guru"
log "DONE" "BUILD guru"
echo ""

# -------------------------------------------------------------------------------
# gorename
# -------------------------------------------------------------------------------
log "START" "BUILD gorename"
go install golang.org/x/tools/cmd/gorename
showError $? "BUILD gorename"
log "DONE" "BUILD gorename"
echo ""

# -------------------------------------------------------------------------------
# golint
# -------------------------------------------------------------------------------
log "START" "BUILD golint"
go install golang.org/x/lint/golint
showError $? "BUILD golint"
log "DONE" "BUILD golint"
echo ""

# -------------------------------------------------------------------------------
# goimports
# -------------------------------------------------------------------------------
log "START" "BUILD goimports"
go install golang.org/x/tools/cmd/goimports
showError $? "BUILD goimports"
log "DONE" "BUILD goimports"
echo ""


# -------------------------------------------------------------------------------
# gopls
# -------------------------------------------------------------------------------
log "START" "BUILD gopls"
github https://github.com/golang/xerrors.git "$GOPATH/src/golang.org/x/xerrors" master
go install golang.org/x/tools/cmd/gopls
showError $? "BUILD gopls"
log "DONE" "BUILD gopls"
echo ""

# -------------------------------------------------------------------------------
# gocode
# -------------------------------------------------------------------------------
build https://github.com/mdempsky/gocode.git gocode github.com/mdempsky/gocode

# -------------------------------------------------------------------------------
# gocode-gomod
# -------------------------------------------------------------------------------
build https://github.com/stamblerre/gocode.git gocode-gomod github.com/stamblerre/gocode

# -------------------------------------------------------------------------------
# gopkgs
# -------------------------------------------------------------------------------
github https://github.com/karrick/godirwalk.git "$GOPATH/src/github.com/karrick/godirwalk" master

github https://github.com/MichaelTJones/walk.git "$GOPATH/src/github.com/MichaelTJones/walk" master

github https://github.com/pkg/errors.git "$GOPATH/src/github.com/pkg/errors" master

build https://github.com/uudashr/gopkgs.git gopkgs github.com/uudashr/gopkgs/cmd/gopkgs

# -------------------------------------------------------------------------------
# go-outline
# -------------------------------------------------------------------------------
build https://github.com/ramya-rao-a/go-outline.git go-outline github.com/ramya-rao-a/go-outline

# -------------------------------------------------------------------------------
# go-symbols
# -------------------------------------------------------------------------------
build https://github.com/acroca/go-symbols.git go-symbols github.com/acroca/go-symbols

# -------------------------------------------------------------------------------
# gomodifytags
# -------------------------------------------------------------------------------
build https://github.com/fatih/gomodifytags.git gomodifytags github.com/fatih/gomodifytags

# -------------------------------------------------------------------------------
# goplay
# -------------------------------------------------------------------------------
github https://github.com/skratchdot/open-golang.git  "$GOPATH/src/github.com/skratchdot/open-golang" master

build https://github.com/haya14busa/goplay.git goplay github.com/haya14busa/goplay/cmd/goplay

# -------------------------------------------------------------------------------
# impl
# -------------------------------------------------------------------------------
build https://github.com/josharian/impl.git impl github.com/josharian/impl

# -------------------------------------------------------------------------------
# gotype-live
# -------------------------------------------------------------------------------
build https://github.com/tylerb/gotype-live.git gotype-live github.com/tylerb/gotype-live

# -------------------------------------------------------------------------------
# godef
# -------------------------------------------------------------------------------
build https://github.com/rogpeppe/godef.git godef github.com/rogpeppe/godef


# -------------------------------------------------------------------------------
# gogetdoc
# -------------------------------------------------------------------------------
build https://github.com/zmb3/gogetdoc.git gogetdoc github.com/zmb3/gogetdoc

# -------------------------------------------------------------------------------
# goreturns
# -------------------------------------------------------------------------------
build https://github.com/sqs/goreturns.git goreturns github.com/sqs/goreturns

# -------------------------------------------------------------------------------
# gotests
# -------------------------------------------------------------------------------
build https://github.com/cweill/gotests.git gotests github.com/cweill/gotests/...

# -------------------------------------------------------------------------------
# gometalinter
# -------------------------------------------------------------------------------
build https://github.com/alecthomas/gometalinter.git gometalinter github.com/alecthomas/gometalinter

# -------------------------------------------------------------------------------
# golangci-lint
# -------------------------------------------------------------------------------
build https://github.com/golangci/golangci-lint.git golangci-lint github.com/golangci/golangci-lint/cmd/golangci-lint

# -------------------------------------------------------------------------------
# revive
# -------------------------------------------------------------------------------
github https://github.com/BurntSushi/toml.git "$GOPATH/src/github.com/BurntSushi/toml" master
github https://github.com/fatih/color.git "$GOPATH/src/github.com/fatih/color" master
github https://github.com/fatih/structtag.git "$GOPATH/src/github.com/fatih/structtag" master
github https://github.com/mgechev/dots.git "$GOPATH/src/github.com/mgechev/dots" master
github https://github.com/olekukonko/tablewriter.git "$GOPATH/src/github.com/olekukonko/tablewriter" master
github https://github.com/mattn/go-runewidth.git "$GOPATH/src/github.com/mattn/go-runewidth" master
build https://github.com/mgechev/revive.git revive github.com/mgechev/revive

# -------------------------------------------------------------------------------
# go-langserver
# -------------------------------------------------------------------------------
build https://github.com/sourcegraph/go-langserver.git go-langserver github.com/sourcegraph/go-langserver

# -------------------------------------------------------------------------------
# dlv
# -------------------------------------------------------------------------------
build https://github.com/go-delve/delve.git dlv github.com/go-delve/delve/cmd/dlv

# -------------------------------------------------------------------------------
# fillstruct
# -------------------------------------------------------------------------------
build https://github.com/davidrjenni/reftools.git fillstruct github.com/davidrjenni/reftools/cmd/fillstruct

# -------------------------------------------------------------------------------
# godoctor 
# -------------------------------------------------------------------------------
build https://github.com/godoctor/godoctor.git godoctor github.com/godoctor/godoctor

# -------------------------------------------------------------------------------
# goformat
# -------------------------------------------------------------------------------
log "START" "BUILD goformat"
github https://github.com/mbenkmann/goformat.git "$GOPATH/src/winterdrache.de/goformat" master
go install winterdrache.de/goformat/goformat
showError $? "BUILD goformat"
log "DONE" "BUILD goformat"
echo ""

# -------------------------------------------------------------------------------
# staticcheck
# -------------------------------------------------------------------------------
log "START" "BUILD staticcheck"
github https://github.com/kisielk/gotool.git  "$GOPATH/src/github.com/kisielk/gotool" master
github https://github.com/google/renameio.git  "$GOPATH/src/github.com/google/renameio" master
github https://github.com/rogpeppe/go-internal.git  "$GOPATH/src/github.com/rogpeppe/go-internal" master
github https://github.com/dominikh/go-tools.git "$GOPATH/src/honnef.co/go/tools" master
go install honnef.co/go/tools/...
showError $? "BUILD staticcheck"
log "DONE" "BUILD staticcheck"
echo ""
