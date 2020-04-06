@ECHO off
CLS

:UpdateSVN
ECHO Processing upstream changes...
ECHO.
svn cleanup
svn update "..\..\master-dan"

:CheckLast
FOR /F "eol=| delims=" %%I IN ('DIR ".\*.txt" /A-D /B /O-D /TW 2^>nul') DO (
    SET LastFile=%%~nI
    GOTO CheckNew
)

:CheckNew
FOR /F "eol=| delims=" %%I IN ('DIR "..\..\master-dan\csse_covid_19_data\csse_covid_19_daily_reports\*.csv" /A-D /B /O-D /TW 2^>nul') DO (
    SET NewFile=%%~nI
    GOTO CheckResult
)

:CheckResult
IF NOT "%LastFile%" == "%NewFile%" (
  GOTO ProcessFiles
)
ECHO. 
ECHO Last Date: %LastFile%  ***  Daily Date: %NewFile%
GOTO SVN

:ProcessFiles
ECHO.
ECHO New files: %NewFile%
ECHO %NewFile% > "daily_date.csv" 
ECHO %NewFile% > "%NewFile%.txt"
DEL "%LastFile%.txt"


ECHO. 
ECHO Merging files...
".\util\FileUtil.exe" merge --folder "..\..\master-dan\csse_covid_19_data\csse_covid_19_daily_reports" --search "*.csv" --file ".\daily_cases\daily_cases_all.csv" --addname true

PING -n 30 127.0.0.1>nul

:SVN
ECHO. 
ECHO SVN commit...
ECHO.
svn commit -m "daily case update"
svn cleanup 
svn update


:EOF
ECHO.
ECHO Daily case update check complete!
PING -n 5 127.0.0.1>nul
EXIT 0