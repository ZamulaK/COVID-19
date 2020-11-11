@ECHO off
CLS

:UpdateSVN
ECHO Processing upstream changes...
ECHO.
svn cleanup
svn update "..\CSSEGISandData\csse_covid_19_daily_reports"

:CheckLast
FOR /F "eol=| delims=" %%I IN ('DIR ".\*.txt" /A-D /B /O-D /TW 2^>nul') DO (
    SET LastFile=%%~nI
    GOTO CheckNew
)

:CheckNew
FOR /F "eol=| delims=" %%I IN ('DIR "..\CSSEGISandData\csse_covid_19_daily_reports\*.csv" /A-D /B /O-N /TW 2^>nul') DO (
    SET NewFile=%%~nI
    GOTO CheckResult
)

:CheckResult
IF NOT "%LastFile%" == "%NewFile%" (
  GOTO ProcessFiles
)
ECHO. 
ECHO Last Date: %LastFile%  ***  Daily Date: %NewFile%
GOTO EOF

:ProcessFiles
ECHO.
ECHO New files: %NewFile%
ECHO %NewFile% > "daily_date.csv" 
ECHO %NewFile% > "%NewFile%.txt"
DEL "%LastFile%.txt"

ECHO. 
ECHO Merging files...
".\util\FileUtil.exe" merge --folder "..\CSSEGISandData\csse_covid_19_daily_reports" --search "*.csv" --file ".\daily_cases\daily_cases_all.csv" --addname NoExt --endcol 12 

:CommitSVN
ECHO. 
ECHO SVN commit...
ECHO.
svn commit -m "daily case update"
svn cleanup 
svn update

:EOF
ECHO.
ECHO Daily case update check complete!
TIMEOUT 5
EXIT 0