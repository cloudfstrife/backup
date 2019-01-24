@echo off 

rem 当前日期 yyyy-MM-dd 
set date_format=%Date:~0,4%-%Date:~5,2%-%Date:~8,2%

rem 获取当前时间 HH:mm:ss
set hour=%time:~0,2%
if   %hour%   LSS  10   set   hour=0%hour:~1,2%
set time_format=%hour%-%time:~3,2%-%time:~6,2%

set host=xxxx.xxxx.xxxx.xxxx
set port=xxxxx
set user=xxxxx
set pass=xxxxx
set databases=xxxx xxxx xxxxx xxxx
set base_folder=X:\xxxx\xxxx
set backup_folder=%base_folder%\%date_format%
set mysql_bin_folder=x:\PATH\TO\MYSQL\bin

set keep_days=2

rem 获取删除目录
echo Wscript.echo dateadd("d",-%keep_days%,date)>vbs.vbs
for /f %%a in ('cscript //nologo vbs.vbs') do del vbs.vbs&&set yyyymmdd=%%a
for /f "tokens=1,2,3* delims=// " %%i in ('echo %yyyymmdd%') do set yyyy=%%i&set mm=%%j&set dd=%%k
if   %mm%   LSS   10   set   mm=0%mm%
if   %dd%   LSS   10   set   dd=0%dd%

set del_folder=%base_folder%\%yyyy%-%mm%-%dd%

if not exist %backup_folder% md %backup_folder%
for %%a in (%databases%) do call:backup %host% %port% %user% %pass% %%a

rmdir /s /q %del_folder%

rem backup function
:backup
set db=%5
if defined db (%mysql_bin_folder%\mysqldump --host=%1 --port=%2 --user=%3 --password=%4 --routines --triggers --databases  %5 > %backup_folder%\%5_%date_format%_%time_format%.sql)
goto:eof
