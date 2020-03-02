#  ******************************************************************************
#  windows 7+ 安装 Visual Studio Code 的go语言插件扩展工具的 Power Shell
#  
#  ****    脚本前置条件    ****
#  * 安装好Go环境 version >= 1.13
#  * 安装好git
#  * 配置GOPATH
#  ******************************************************************************

$pwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
# -------------------------------------------------------------------------------
# TOOLS_LIST_FILE_NAME 包含工具列表的CSV文件
# -------------------------------------------------------------------------------
$TOOLS_LIST_FILE_NAME="$pwd\all_tools_information.csv"

# -------------------------------------------------------------------------------
# git项目URL后缀
# -------------------------------------------------------------------------------
$GIT_POSTFIX=".git"

# -------------------------------------------------------------------------------
# git项目URL后缀
# -------------------------------------------------------------------------------
$GIT_PREFIX="https://"

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
#  克隆git项目到本地
#  参数1 git URL
#  参数2 目标目录
#  参数3 分支
# -------------------------------------------------------------------------------
function github_clone($url,$target_path,$branch){
    log "INFO " "START CLONE $url"
    $null = New-Item -path $target_path -type directory -force
    git clone -q $url $target_path
    showError $? "CLONE $url"
    Set-Location $target_path
    git checkout -q $branch
    showError $? "CHECKOUT $url TO $branch branch"
    log "INFO " "DONE CLONE $url"
}

# -------------------------------------------------------------------------------
#  拉取git项目指定分支到本地
#  参数1 git URL
#  参数2 目标目录
#  参数3 分支
# -------------------------------------------------------------------------------
function github_checkout($url,$target_path,$branch){
    Set-Location $target_path
    
    $GIT_ALICE_NAME=(cmd /c git remote show)
    $GIT_REMOTE_URL=(cmd /c git remote get-url --all $GIT_ALICE_NAME)
    
    if ( ! $url -eq $GIT_REMOTE_URL ){
        showError $false "git remote url do not match"
    }
    log "INFO " "START PULL $url"
    git checkout -- .
    git checkout -q $brench
    showError $? "Switch to $brench branch"
    git pull -q $GIT_ALICE_NAME $brench
    showError $? "Pulling code from remote git branch $brench"
    log "INFO " "DONE PULL $url"
}

# -------------------------------------------------------------------------------
# 克隆（拉取）git 项目指定分支到指定目录
#  参数1 git地址
#  参数2 项目所在目录
#  参数3 分支
# -------------------------------------------------------------------------------
function github($url,$target_path,$branch){
    if ( [String]::IsNullOrEmpty($branch) ){
        showError $false "github function invoked without enough parameter"
    }
    if ( Test-Path $target_path ){
        github_checkout $url $target_path $branch
    }else{
        github_clone $url $target_path $branch
    }
}

# -------------------------------------------------------------------------------
# 构建Go程序
#  参数1 程序源代码所在目录
#  参数2 程序名称
#  参数3 go install 
# -------------------------------------------------------------------------------
function gobuild($source_folder,$app_name,$install_cmd){
    if ( ! (Test-Path $source_folder ) ){
        showError $false "Folder [ $source_folder ] Not exists"
    }
    
    log "INFO " "START BUILD $app_name"
    Set-Location $source_folder
    
    if ( $app_name.Contains("-gomod") ){
        go build -o "$INSTALL_PATH\bin\$app_name.exe"
        showError $? "BUILD $app_name"
    }else{
        go install $install_cmd
        showError $? "BUILD $app_name"
    }
    
    log "INFO " "DONE BUILD $app_name"
}


# -------------------------------------------------------------------------------
# 准备
# 1> 检查Go环境变量设置是否正确
# 2> 设置 go module proxy 
# 3> 清除$GOPATH/bin 和 go module 缓存
# -------------------------------------------------------------------------------
function prepare(){
    # 检查环境变量
    if ( "$env:GOROOT" -eq "" ){
        showError $false "Environment variables [GOROOT] NOT set"
    }
    
    if ( "$env:GOPATH" -eq "" ){
        showError $false "Environment variables [GOPATH] NOT set"
    }
    
	# -------------------------------------------------------------------------------
	# 安装目录
	# -------------------------------------------------------------------------------
	if ( $env:GOPATH.IndexOf(';') > 0 ){
		$INSTALL_PATH=$env:GOPATH.Substring(0,$env:GOPATH.IndexOf(';'))
	}else{
		$INSTALL_PATH=$env:GOPATH
	}
	
    # 设置代理和验证服务器
    go env -w GOPROXY=https://goproxy.io,direct
    go env -w GOSUMDB=sum.golang.google.cn
	
	Write-Output "######################################################################"
	Write-Output "## GOPATH : $env:GOPATH"
	Write-Output "## Install in to : $INSTALL_PATH"
	Write-Output "######################################################################"
	
    if ( Test-Path $INSTALL_PATH/bin  ){
        Remove-Item $INSTALL_PATH/bin/* -recurse
    }
    
    # 清理模块缓存 
    go clean -modcache
    
    # 拉取golang.org的库，解决非go module模式的扩展工具的依赖问题
    github $GIT_PREFIX"github.com/golang/build"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\build" master
    github $GIT_PREFIX"github.com/golang/crypto"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\crypto" master
    github $GIT_PREFIX"github.com/golang/xerrors"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\xerrors" master
    github $GIT_PREFIX"github.com/golang/exp"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\exp" master
    github $GIT_PREFIX"github.com/golang/image"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\image" master
    github $GIT_PREFIX"github.com/golang/lint"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\lint" master
    github $GIT_PREFIX"github.com/golang/mobile"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\mobile" master
    github $GIT_PREFIX"github.com/golang/mod"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\mod" master
    github $GIT_PREFIX"github.com/golang/net"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\net" master
    github $GIT_PREFIX"github.com/golang/oauth2"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\oauth2" master
    github $GIT_PREFIX"github.com/golang/perf"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\perf" master
    github $GIT_PREFIX"github.com/golang/review"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\review" master
    github $GIT_PREFIX"github.com/golang/sync"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\sync" master
    github $GIT_PREFIX"github.com/golang/sys"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\sys" master
    github $GIT_PREFIX"github.com/golang/text"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\text" master
    github $GIT_PREFIX"github.com/golang/tools"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\tools" master
    github $GIT_PREFIX"github.com/golang/time"$GIT_POSTFIX "$INSTALL_PATH\src\golang.org\x\time" master
	github $GIT_PREFIX"github.com/skratchdot/open-golang"$GIT_POSTFIX "$INSTALL_PATH\src\github.com\skratchdot\open-golang" master
	
}

# -------------------------------------------------------------------------------
# 重置 go module proxy 设置
# -------------------------------------------------------------------------------
function ending(){
    go env -u GOPROXY
    go env -u GOSUMDB
}

function main(){
	# -------------------------------------------------------------------------------
	# 安装目录
	# -------------------------------------------------------------------------------
	if ( $env:GOPATH.IndexOf(';') > 0 ){
		$INSTALL_PATH=$env:GOPATH.Substring(0,$env:GOPATH.IndexOf(';'))
	}else{
		$INSTALL_PATH=$env:GOPATH
	}
	
    Import-Csv $TOOLS_LIST_FILE_NAME | ForEach-Object {
        $name=$_.name
        $github=$_.github
        $folder=$_.folder
        $build_folder=$_.build_folder
		$install_cmd=$_.install_cmd
        
        $target_folder=$folder.Replace("/","\")
        
		Write-Output "######################################################################"
        Write-Output "##                          $name"
		Write-Output "######################################################################"
		
		github "$GIT_PREFIX$github$GIT_POSTFIX" "$INSTALL_PATH\src\$target_folder" "master"
        gobuild "$INSTALL_PATH\src\$build_folder" "$name" "$install_cmd"
    }
}

# -------------------------------------------------------------------------------
# begin
# -------------------------------------------------------------------------------
prepare

main

ending