@echo off

rem �ж��Ƿ���ڲ���

set ONE=%1

rem ��ȡ��ǰGOPATH�е�һ������
set FIRST=%GOPATH%
if not "%GOPATH%"=="" (
    for /f "tokens=1 delims=;" %%F in ("%GOPATH%") do set FIRST=%%F
)

rem �ж�PATH���Ƿ����GOPATH�ĵ�һ��Ŀ¼�µ�binĿ¼
echo %PATH% | findstr %FIRST% >nul || set "PATH=%PATH%%FIRST%\bin"

if not "%ONE%"=="" (
    rem �ж�GOPATH���Ƿ��в���1
    echo %GOPATH% | findstr %ONE% >nul || set GOPATH=%GOPATH%;%ONE%
)
