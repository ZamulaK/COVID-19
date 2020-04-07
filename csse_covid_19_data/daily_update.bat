@ECHO off
REM CLS

:UpdateSVN
REM ECHO Processing upstream changes...
REM ECHO.
svn cleanup
svn update "..\CSSEGISandData\csse_covid_19_daily_reports"

:CheckLast
FOR /F "eol=| delims=" %%I IN ('DIR ".\*.txt" /A-D /B /O-D /TW 2^>nul') DO (
    SET LastFile=%%~nI
    GOTO CheckNew
)

:CheckNew
FOR /F "eol=| delims=" %%I IN ('DIR "..\CSSEGISandData\csse_covid_19_daily_reports\*.csv" /A-D /B /O-D /TW 2^>nul') DO (
    SET NewFile=%%~nI
    GOTO CheckResult
)

:CheckResult
IF NOT "%LastFile%" == "%NewFile%" (
  GOTO ProcessFiles
)
REM ECHO. 
REM ECHO Last Date: %LastFile%  ***  Daily Date: %NewFile%
GOTO SVN

:ProcessFiles
REM ECHO.
REM ECHO New files: %NewFile%
ECHO %NewFile% > "daily_date.csv" 
ECHO %NewFile% > "%NewFile%.txt"
DEL "%LastFile%.txt"


REM ECHO. 
REM ECHO Merging files...
".\util\FileUtil.exe" merge --folder "..\CSSEGISandData\csse_covid_19_daily_reports" --search "*.csv" --file ".\daily_cases\daily_cases_all.csv" --addname true

PING -n 20 127.0.0.1>nul

:SVN
REM ECHO. 
REM ECHO SVN commit...
REM ECHO.
svn commit -m "daily case update"
svn cleanup 
svn update


:EOF
REM ECHO.
REM ECHO Daily case update check complete!
PING -n 5 127.0.0.1>nul
EXIT 0