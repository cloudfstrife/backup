#  ******************************************************************************
#  windows 7+ 安装 Visual Studio Code 的go语言插件扩展工具的shell
#  
#  ****    脚本前置条件    ****
#  * 安装好Go环境
#  * 安装好git
#  
#  ******************************************************************************

# git项目URL后缀
$GIT_POSTFIX=".git"
# git项目URL后缀
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
	if ( ! ( Test-Path "$target_path\.git") ){
		showError $false "target folder is not a git project folder"
	}
	
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
#  参数3 go build 路径
# -------------------------------------------------------------------------------
function gobuild($source_folder,$app_name,$build_path){
	if ( ! (Test-Path $source_folder ) ){
		showError $false "Folder [ $source_folder ] Not exists"
	}
	
	log "INFO " "START BUILD $app_name"
	Set-Location $source_folder
	
	if ( $app_name.Contains("-gomod") ){
        go build -o "$env:GOPATH\bin\$app_name.exe"
        showError $? "BUILD $app_name"
    }else{
        go install $build_path
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
    if ( "$env:GOROOT" -eq "" ){
		showError $false "Environment variables [GOROOT] NOT set"
	}
	
	if ( "$env:GOPATH" -eq "" ){
		showError $false "Environment variables [GOPATH] NOT set"
	}
	
	# 
	go env -w GOPROXY=https://goproxy.io,direct
	go env -w GOSUMDB=sum.golang.google.cn
	
    if ( Test-Path $env:GOPATH/bin  ){
		Remove-Item $env:GOPATH/bin/* -recurse
	}
	
	go clean -modcache
}

# -------------------------------------------------------------------------------
# 重置 go module proxy 设置
# -------------------------------------------------------------------------------
function ending(){
	go env -u GOPROXY
	go env -u GOSUMDB
}

function main(){
	Import-Csv all_tools_information.Csv | ForEach-Object {
		$name=$_.name
		$github=$_.github
		$folder=$_.folder
		$build=$_.build
		
		$target_folder=$folder.Replace("/","\")
		
		Write-Output "-------------------------------  $name  -------------------------------"
		
		github "$GIT_PREFIX$github$GIT_POSTFIX" "$env:GOPATH\src\$target_folder" "master"
		gobuild "$env:GOPATH\src\$target_folder" "$name" "$build"
	}
}

# -------------------------------------------------------------------------------
# begin
# -------------------------------------------------------------------------------
prepare

main

ending