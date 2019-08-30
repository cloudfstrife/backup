#!/bin/bash

# Hugo 源代码git地址
SOURCE_REPOSITORY=https://github.com/cloudfstrife/Hermes.git
# Hugo 源代码目录
SOURCE_FOLDER=/data/github/Hermes
#Hugo 可执行程序位置
HUGO_BIN=/usr/local/bin/hugo
# 静态文件部署位置
DEPLOY_FOLDER=/data/www

# -------------------------------------------------------------------------------
#  处理错误
#  参数1 上一命令返回状态，一般为$?
#  参数2 任务说明
# -------------------------------------------------------------------------------
function ShowError(){
    if [ $1 != "0" ]; then
        Log "ERROR" "$2"
        exit 1
    fi 
}

# -------------------------------------------------------------------------------
#  日志输出
#  参数1 日志级别
#  参数2 日志内容
# -------------------------------------------------------------------------------
function Log(){
    printf "%s [ %-7s ] : %s\n" "$(date '+%F %T')" "$1" "$2"
}

Fetch(){
    if [ ! -d ${SOURCE_FOLDER} ]; then 
        mkdir -p ${SOURCE_FOLDER}
        git clone ${SOURCE_REPOSITORY} ${SOURCE_FOLDER} 2>&1
        cd ${SOURCE_FOLDER}
        git submodule update --init --recursive 2>&1
    else
        cd ${SOURCE_FOLDER}
        git pull origin 2>&1 
    fi
}

Compile(){
    rm -rf ${SOURCE_FOLDER}/public 
    cd ${SOURCE_FOLDER}
    ${HUGO_BIN}
}

Deploy(){
    if [ ! -d ${DEPLOY_FOLDER} ]; then 
        mkdir -p ${DEPLOY_FOLDER}
    fi
    rm -rf ${DEPLOY_FOLDER}/*
    cp -r ${SOURCE_FOLDER}/public/* ${DEPLOY_FOLDER}
}

Main(){
    Fetch
    Compile
    Deploy
}

Main
