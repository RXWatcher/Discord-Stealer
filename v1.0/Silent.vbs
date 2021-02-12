Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & WScript.Arguments(0) & Chr(34), 0
Set WshShell = Nothing