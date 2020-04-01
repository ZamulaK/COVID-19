mktoapi export --object Lead --file MktoExport.csv --template MktoTemp.txt --filter Updated --date1 "2020-03-09 17:00" --date2 "2020-03-09 22:00"
mktoapi export --object Lead --file MktoExport.csv --template MktoTemp.txt --filter SmartList --list "DTH Export - Person"
mktoapi export --object Lead --file MktoExport.csv --template MktoTemp.txt --filter StaticList --list 7
mktoapi import --object Lead  -file MktoPubs.csv --list 112 --lines 5


mktoapi merge --folder . --search mktoPubOut-?.csv --file TestMerge.csv --addname true

sqlcmd -d wwrm -Q "EXEC usp_mktoFilePersonCRM" -h-1 -k2  -s "|" -W -u -o "L:\Temp\mktoPersonOut.csv"
exec usp_utility 'sqlcmd', '-d wwrm -Q "EXEC usp_mktoFileLeadCRM ''CIS'', ''|''" -h-1 -k2 -s "|" -W -f 65001 -o "L:\Temp\mktLeadOut.psv"'
exec usp_utility 'sqlcmd', '-d wwrm -Q "EXEC usp_mktoFilePubCRM '',''" -h-1 -k2 -s "," -W -f 65001 -o "L:\Temp\mktoPubOut.csv"'
