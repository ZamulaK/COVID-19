@ECHO off
CLS

ECHO. 
ECHO Merging files...
".\util\FileUtil.exe" merge --folder "..\CSSEGISandData\csse_covid_19_daily_reports" --search "*.csv" --dateMin "10-01-2020" --file ".\daily_cases\daily_cases_all.csv" --addname NoExt --endcol 12 

