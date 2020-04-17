@echo off

rem 判断是否存在参数

set ONE=%1

rem 获取当前GOPATH中第一个参数
set FIRST=%GOPATH%
if not "%GOPATH%"=="" (
    for /f "tokens=1 delims=;" %%F in ("%GOPATH%") do set FIRST=%%F
)

rem 判断PATH中是否存在GOPATH的第一个目录下的bin目录
echo %PATH% | findstr %FIRST% >nul || set "PATH=%PATH%%FIRST%\bin"

if not "%ONE%"=="" (
    rem 判断GOPATH中是否有参数1
    echo %GOPATH% | findstr %ONE% >nul || set GOPATH=%GOPATH%;%ONE%
)
