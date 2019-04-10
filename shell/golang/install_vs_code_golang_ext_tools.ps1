#  ******************************************************************************
#  windows 7+ 安装 Visual Studio Code 的go语言插件扩展工具的shell
#  
#  ****    脚本前置条件    ****
#  * 安装好Go环境
#  * 配置好GOPATH环境变量，目前只支持一个目录
#  * 安装好git
#  
#  ****    脚本后置操作    ****
#  gometalinter --install
#
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
$GIT_POSTFIX=".git"
# git项目URL后缀
$GIT_PREFIX="https://"
# build函数中去除的部分
$REMOVE="/..."

# -------------------------------------------------------------------------------
#  处理错误
#  参数1 上一命令返回状态，一般为$?
#  参数2 任务说明
# -------------------------------------------------------------------------------
function showError([String]$status,$context){
    if ( !$status.Equals("True") ){
        log "ERROR" "$context"
        exit 1
    }
}

# -------------------------------------------------------------------------------
#  日志输出
#  参数1 日志级别
#  参数2 日志内容
# -------------------------------------------------------------------------------
function log($status,$context){
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [ $status ] : $context"
}

# -------------------------------------------------------------------------------
# 克隆（拉取）git 项目指定分支到指定目录
# github https://github.com/golang/tools.git "$env:GOPATH/src/golang.org/x/tools" master
# -------------------------------------------------------------------------------
function github($url,$target_path,$branch){
    if ( [String]::IsNullOrEmpty($branch) ){
        showError $false "github function invoked without enough parameter"
    }
    if ( Test-Path $target_path ){
        Set-Location $target_path
        if ( ! ( Test-Path "$target_path\.git") ){
            showError $false "target folder is not a git project folder"
        }
        
        $GIT_ALICE_NAME=(cmd /c git remote show)
        $GIT_REMOTE_URL=(cmd /c git remote get-url --all $GIT_ALICE_NAME)
        
        if ( ! $url -eq $GIT_REMOTE_URL ){
            showError $false "git remote url do not match"
        }
        log "START" "PULL $url"
        git checkout -q $brench
        showError $? "Switch to $brench branch"
        git pull -q $GIT_ALICE_NAME $brench
        showError $? "Pulling code from remote git branch $brench"
        log "DONE" "PULL $url"
    }else{
        log "START" "CLONE $url"
        $null = New-Item -path $target_path -type directory -force
        git clone -q $url $target_path
        showError $? "CLONE $url"
        Set-Location $target_path
        git checkout -q $branch
        showError $? "CHECKOUT $url TO $branch branch"
        log "DONE" "CLONE $url"
    }
}

# -------------------------------------------------------------------------------
# 构建 go 扩展依赖工具
# 参数一：git仓库地址
# 参数二：工具名称
# 参数二：go install 的URL
# 示例：
# build https://github.com/mdempsky/gocode.git gocode github.com/mdempsky/gocode
# -------------------------------------------------------------------------------
function build($url,$tool_name,$build_path){
    if ( [String]::IsNullOrEmpty($build_path) ){
        showError $false "build function invoked without enough parameter"
    }

    log "START" "BUILD $tool_name"
    
    $TARGET_FOLDER=$url.Replace($GIT_PREFIX,"").Replace($GIT_POSTFIX,"").Replace("/","\")

    github $url "$env:GOPATH\src\$TARGET_FOLDER" master

    if ( $tool_name.Contains("-gomod") ){
        go build -o "$env:GOPATH\bin\$tool_name.exe" $build_path
        showError $? "BUILD $tool_name"
    }else{
        go install $build_path
        showError $? "BUILD $tool_name"
    }
    log "DONE" "BUILD $tool_name"
    Write-Output ""
}

# -------------------------------------------------------------------------------
# golang
# -------------------------------------------------------------------------------
log "START" "FETCH golang build-in tools"
Write-Output ""

github https://github.com/golang/tools.git "$env:GOPATH/src/golang.org/x/tools" master
Write-Output ""

github https://github.com/golang/mobile.git "$env:GOPATH/src/golang.org/x/mobile" master
Write-Output ""

github https://github.com/golang/net.git "$env:GOPATH/src/golang.org/x/net" master
Write-Output ""

github https://github.com/golang/crypto.git "$env:GOPATH/src/golang.org/x/crypto" master
Write-Output ""

github https://github.com/golang/exp.git "$env:GOPATH/src/golang.org/x/exp" master
Write-Output ""

github https://github.com/golang/vgo.git "$env:GOPATH/src/golang.org/x/vgo" master
Write-Output ""

github https://github.com/golang/sys.git "$env:GOPATH/src/golang.org/x/sys" master
Write-Output ""

github https://github.com/golang/text.git "$env:GOPATH/src/golang.org/x/text" master
Write-Output ""

github https://github.com/golang/lint.git "$env:GOPATH/src/golang.org/x/lint" master
Write-Output ""

github https://github.com/golang/image.git "$env:GOPATH/src/golang.org/x/image" master
Write-Output ""

github https://github.com/golang/time.git "$env:GOPATH/src/golang.org/x/time" master
Write-Output ""

github https://github.com/golang/sync.git "$env:GOPATH/src/golang.org/x/sync" master
Write-Output ""

log "DONE" "FETCH golang build-in tools"
Write-Output ""

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
github https://github.com/karrick/godirwalk.git "$env:GOPATH/src/github.com/karrick/godirwalk" master

github https://github.com/MichaelTJones/walk.git "$env:GOPATH/src/github.com/MichaelTJones/walk" master

github https://github.com/pkg/errors.git "$env:GOPATH/src/github.com/pkg/errors" master

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
github https://github.com/skratchdot/open-golang.git  "$env:GOPATH/src/github.com/skratchdot/open-golang" master

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
github https://github.com/BurntSushi/toml.git "$env:GOPATH/src/github.com/BurntSushi/toml" master
github https://github.com/fatih/color.git "$env:GOPATH/src/github.com/fatih/color" master
github https://github.com/fatih/structtag.git "$env:GOPATH/src/github.com/fatih/structtag" master
github https://github.com/mgechev/dots.git "$env:GOPATH/src/github.com/mgechev/dots" master
github https://github.com/olekukonko/tablewriter.git "$env:GOPATH/src/github.com/olekukonko/tablewriter" master
github https://github.com/mattn/go-runewidth.git "$env:GOPATH/src/github.com/mattn/go-runewidth" master
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
github https://github.com/mbenkmann/goformat.git "$env:GOPATH/src/winterdrache.de/goformat" master
go install winterdrache.de/goformat/goformat
showError $? "BUILD goformat"
log "DONE" "BUILD goformat"
echo ""

# -------------------------------------------------------------------------------
# staticcheck
# -------------------------------------------------------------------------------
log "START" "BUILD staticcheck"
github https://github.com/kisielk/gotool.git  "$env:GOPATH/src/github.com/kisielk/gotool" master
github https://github.com/dominikh/go-tools.git "$env:GOPATH/src/honnef.co/go/tools" master
go install honnef.co/go/tools/...
showError $? "BUILD staticcheck"
log "DONE" "BUILD staticcheck"
echo ""
