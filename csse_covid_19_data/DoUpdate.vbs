dim sh
dim q
dim arg

q = chr(34)
set sh = createobject("wscript.shell")

on error resume next

sh.run q & "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe" & q & " /shutdown", 0, true
sh.run q & "daily_update.bat" & q, 0, true
sh.run q & "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe" & q & " /background", 0, false

set sh = nothing
wscript.quit(0)
