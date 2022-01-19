@echo off
setlocal enabledelayedexpansion

set RickRoll-Plugin=true

if "!RickRoll-Plugin!"=="true" (
    >rr.vbs echo dim oPlayer : set oPlayer = CreateObject^("WMPlayer.OCX"^) :   oPlayer.URL = "RickRoll.mp3" : oPlayer.controls.play : while oPlayer.playState  ^<^> 1 : WScript.Sleep 100 : Wend : oPlayer.close

    start /b "" cscript rr.vbs>nul
    timeout /t 3 >nul
    del /s /q rr.vbs>nul
)


pause