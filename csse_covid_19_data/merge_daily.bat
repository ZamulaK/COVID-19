@ECHO off

:UpdateSVN
call "..\..\trunk\csse_covid_19_data\update.bat"

:CheckLast
FOR /F "eol=| delims=" %%I IN ('DIR ".\*.txt" /A-D /B /O-D /TW 2^>nul') DO (
    SET LastFile=%%~nI
    GOTO CheckNew
)

:CheckNew
FOR /F "eol=| delims=" %%I IN ('DIR "..\..\trunk\csse_covid_19_data\csse_covid_19_daily_reports\*.csv" /A-D /B /O-D /TW 2^>nul') DO (
    SET NewFile=%%~nI
    GOTO CheckResult
)

:CheckResult
IF NOT "%LastFile%" == "%NewFile%" (
  GOTO ProcessFiles
)
ECHO "No new files: %LastFile%"
GOTO EOF

:ProcessFiles
ECHO %NewFile% > "%NewFile%.txt"
DEL "%LastFile%.txt"

ECHO "Merging files..."
".\util\mktoapi.exe" merge --folder "..\..\trunk\csse_covid_19_data\csse_covid_19_daily_reports" --search "*.csv" --file ".\daily_cases\daily_cases_all.csv" --addname true

ECHO "SVN commit..."
rem svn commit -m "daily case update"
rem svn cleanup
rem svn update
rem exit 0

:EOF