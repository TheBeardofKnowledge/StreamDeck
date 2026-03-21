```batch
@ECHO OFF
SETLOCAL EnableDelayedExpansion
COLOR f0
TITLE Universal Stream Deck to Ajazz Migrator

:: ========================================================================
:: Admin-Check
:: ========================================================================
:checkPrivileges
NET FILE 1>NUL 2>NUL
IF '%errorlevel%' == '0' ( GOTO gotPrivileges ) ELSE (
    ECHO [!] Requesting Admin Privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0 %*' -Verb RunAs"
    EXIT /B
)

:gotPrivileges
CLS
ECHO ============================================================
ECHO          SEARCHING FOR INSTALLATIONS (ELGATO ^& AJAZZ)
ECHO ============================================================
ECHO.

:: --- SEARCH FOR AJAZZ ---
SET "AJAZZ_PROG="
SET "AJAZZ_DATA=%AppData%\HotSpot\StreamDock"

:: 1. Check Registry for Ajazz
FOR /F "tokens=2*" %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Stream Dock" /v "InstallLocation" 2^>NUL') DO SET "AJAZZ_PROG=%%B"

:: 2. Deep Search for Ajazz if not found
IF NOT EXIST "%AJAZZ_PROG%\Stream Dock AJAZZ.exe" (
    ECHO [Search] Looking for Ajazz executable...
    FOR %%D IN (C D E F G) DO (
        IF EXIST "%%D:\" (
            FOR /F "delims=" %%F IN ('where /r "%%D:\Program Files (x86)" "Stream Dock AJAZZ.exe" 2^>NUL') DO SET "AJAZZ_PROG=%%~dpF"
        )
    )
)

:: --- SEARCH FOR ELGATO ---
SET "ELGATO_DATA="
:: Check Standard Path
IF EXIST "%AppData%\Elgato\StreamDeck\" (
    SET "ELGATO_DATA=%AppData%\Elgato\StreamDeck"
) ELSE (
    ECHO [Search] Looking for Elgato AppData...
    FOR %%D IN (C D E F G) DO (
        IF EXIST "%%D:\" (
            FOR /D /R "%%D:\" %%G IN ("Elgato\StreamDeck") DO (
                IF EXIST "%%G\Plugins" SET "ELGATO_DATA=%%G"
            )
        )
    )
)

:: --- STATUS REPORT ---
ECHO ------------------------------------------------------------
IF DEFINED ELGATO_DATA ( ECHO [OK] Elgato Path: "%ELGATO_DATA%" ) ELSE ( ECHO [!!] Elgato NOT found! )
IF EXIST "%AJAZZ_PROG%" ( ECHO [OK] Ajazz Path:  "%AJAZZ_PROG%" ) ELSE ( ECHO [!!] Ajazz NOT found! )
ECHO ------------------------------------------------------------
ECHO.

IF NOT DEFINED ELGATO_DATA ( ECHO Error: Elgato data not found. & PAUSE & EXIT /B )
IF NOT EXIST "%AJAZZ_PROG%" ( SET /P "AJAZZ_PROG=Please enter Ajazz folder path manually: " )

ECHO Press any key to start migration...
PAUSE >nul
CLS

:: ========================================================================
:: MIGRATION
:: ========================================================================
ECHO [+] Syncing Plugins...
xcopy "%ELGATO_DATA%\Plugins\*" "%AJAZZ_DATA%\plugins\" /d /e /c /i /k /o /y /r

ECHO.
ECHO [+] Syncing Icon Packs...
xcopy "%ELGATO_DATA%\IconPacks\*" "%AJAZZ_DATA%\icons\" /d /e /c /i /k /o /y /r

ECHO.
ECHO [+] Clearing Cache...
IF EXIST "%AJAZZ_DATA%\storecache\storecache.json" (
    DEL /F /Q "%AJAZZ_DATA%\storecache\storecache.json"
)

:: ========================================================================
:: RESTART
:: ========================================================================
ECHO.
ECHO [+] Restarting Ajazz StreamDock...
TASKKILL /F /IM "Stream Dock AJAZZ.exe" /T >nul 2>&1
TIMEOUT /T 2 >nul

IF "!AJAZZ_PROG:~-1!"=="\" SET "AJAZZ_PROG=!AJAZZ_PROG:~0,-1!"
CD /D "%AJAZZ_PROG%"
START "" "Stream Dock AJAZZ.exe"

ECHO.
ECHO ============================================================
ECHO    SUCCESS! Migration Complete.
ECHO ============================================================
TIMEOUT /T 10
EXIT
