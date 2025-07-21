::For the Ulanzi D200
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
ECHO Copying plugins from ElMeow to Ulanzi
	xcopy "%AppData%\Elgato\StreamDeck\Plugins\" "%AppData%\Ulanzi\UlanziDeck\plugins\" /d /e /c /i /k /o /y /r ::>nul 2>&1
ECHO Copying Icon Packs from ElMeow to Ulanzi
	xcopy "%AppData%\Elgato\StreamDeck\IconPacks\" "%AppData%\Ulanzi\UlanziDeck\icons\" /d /e /c /i /k /o /y /r ::>nul 2>&1
ECHO Clearing the Ulanzi store plugins cache and restarting the APP
	taskkill /f /IM "UlanziDeck.exe" 
 del /S /Q /F "%AppData%\Ulanzi\UlanziDeck\storecache\storecache.json
		cd "C:\Program Files (x86)\UlanziDeck\"
	"UlanziDeck.exe"
If theres any errors above - please copy them and report them in the github 
PAUSE
