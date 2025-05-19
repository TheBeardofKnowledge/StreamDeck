
@ECHO OFF
	color f0
ECHO =============================
ECHO Running Admin shell
ECHO =============================
 
:checkPrivileges 
	NET FILE 1>NUL 2>NUL
	if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 
:getPrivileges
:Not elevated, so re-run with elevation
	powershell -Command "Start-Process cmd -ArgumentList '/c %~s0 %*' -Verb RunAs"
	exit /b
	)
:gotPrivileges 
	cls
ECHO Copying plugins from ElMeow to Ajazz
	xcopy "%AppData%\Elgato\StreamDeck\Plugins\" "%AppData%\HotSpot\StreamDock\plugins\" /d /e /c /i /k /o /y /r >nul 2>&1
ECHO Copying Icon Packs from ElMeow to Ajazz
	xcopy "%AppData%\Elgato\StreamDeck\IconPacks\" "%AppData%\HotSpot\StreamDock\icons\" /d /e /c /i /k /o /y /r >nul 2>&1
ECHO Clearing the Ajazz store plugins cache
	del /S /Q /F "%AppData%\HotSpot\StreamDock\storecache\storecache.json
	taskkill /f /IM "Stream Deck AJAZZ.exe" 
	cd "C:\Program Files (x86)\Stream dock ajazz\"
	"Stream Deck AJAZZ.exe"
