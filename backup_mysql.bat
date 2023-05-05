cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"

@REM credentials to connect to mysql server
set mysql_user=root
set mysql_password=dtd2002
set mysql_port=3308

@REM backup file name generation
set backup_path=D:\Project\book\backup-database
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set timestamp=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%-%ldt:~10,2%

@REM backup creation
mysqldump --user=%mysql_user% --password=%mysql_password% --port=%mysql_port% --routines --triggers --databases w22g7_geek --result-file="%backup_path%\%timestamp%_database.sql"
if %ERRORLEVEL% neq 0 (
    (echo %timestamp%: Backup failed! Error during dump creation) >> "%backup_path%\backup_mysql_log.txt"
) else (echo %timestamp%: Backup successful) >> "%backup_path%\backup_mysql_log.txt"

@REM push to github
cd "D:\Project\book\backup-database"
git add . 
git commit -m "scheduled backup database"
git push
