::Reckon Accounts Installation - Firewall Exceptions & User Permissions (RA-INSTALLPREP.bat)
::Place RA-INSTALLPREP.bat file in your datafile (QBW) location.
::Run as Administrator.
@ECHO OFF
SETLOCAL
CLS

::Usergroup Default Setting (change if required)
:: example(set DEFAULT_USERGROUP=Reckon_Users) will set folder permissions of the 'Reckon_Users' group to modify.
set DEFAULT_USERGROUP=everyone

::DONT NOT CHANGE
set TITLE=Reckon Accounts Installation
TITLE %TITLE%

::Run As Administrator Check
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% EQU 0 (
	GOTO Start
) ELSE (
	ECHO.
	ECHO Please run this file as an Administrator!.
	ECHO Exiting...
	Pause
	EXIT /B 1
)

:Start
set DATAFOLDER=%~dp0
IF %DATAFOLDER:~-1%==\ SET DATAFOLDER=%DATAFOLDER:~0,-1%

ECHO *** %TITLE% ***
ECHO *** Firewall Exceptions and Folder Permissions ***
ECHO.
ECHO 1.Reckon Accounts 2013
ECHO 2.Reckon Accounts 2014
ECHO 3.Reckon Accounts 2015
ECHO 4.Reckon Accounts 2016
ECHO 5.Reckon Accounts 2017
ECHO 6.Reckon Accounts 2018
ECHO 7.Reckon Accounts 2019
ECHO 8.Reckon Accounts 2020
ECHO 8.Reckon Accounts 2021
ECHO. 

CHOICE /C 123456789 /M "Select a Version:"

IF ERRORLEVEL 9 GOTO 2021
IF ERRORLEVEL 8 GOTO 2020
IF ERRORLEVEL 7 GOTO 2019
IF ERRORLEVEL 6 GOTO 2018
IF ERRORLEVEL 5 GOTO 2017
IF ERRORLEVEL 4 GOTO 2016
IF ERRORLEVEL 3 GOTO 2015
IF ERRORLEVEL 2 GOTO 2014
IF ERRORLEVEL 1 GOTO 2013

:2013
set YEAR=2013
set PORT=10176
set FOLDER=ReckonAccounts 2013
set DATAUSER=QBDataServiceUser22
goto CheckOS

:2014
set YEAR=2014
set PORT=10177
set FOLDER=Reckon Accounts 2014
set DATAUSER=QBDataServiceUser23
goto CheckOS

:2015
set YEAR=2015
set PORT=10178
set FOLDER=Reckon Accounts 2015
set DATAUSER=QBDataServiceUser24
goto CheckOS

:2016
set YEAR=2016
set PORT=10179
set FOLDER=Reckon Accounts 2016
set DATAUSER=QBDataServiceUser25
goto CheckOS

:2017
set YEAR=2017
set PORT=10180
set FOLDER=Reckon Accounts 2017
set DATAUSER=QBDataServiceUser26
goto CheckOS

:2018
set YEAR=2018
set PORT=10181
set FOLDER=Reckon Accounts 2018
set DATAUSER=QBDataServiceUser27
goto CheckOS

:2019
set YEAR=2019
set PORT=10182
set FOLDER=Reckon Accounts 2019
set DATAUSER=QBDataServiceUser28
goto CheckOS

:2020
set YEAR=2020
set PORT=10183
set FOLDER=Reckon Accounts 2020
set DATAUSER=QBDataServiceUser29
goto CheckOS

:2021
set YEAR=2021
set PORT=10184
set FOLDER=Reckon Accounts 2021
set DATAUSER=QBDataServiceUser30
goto CheckOS

:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" ( GOTO 64Bit ) ELSE ( GOTO 32Bit )

:32Bit
set INSTALL=%PROGRAMFILES%
goto Exceptions

:64Bit
set INSTALL=%PROGRAMFILES(X86)%
goto Exceptions

:Exceptions
ECHO.
ECHO 1.Add %YEAR% Exceptions
ECHO 2.Delete %YEAR% Exceptions
ECHO.

CHOICE /C 12 /M "Select a Action:"

IF ERRORLEVEL 2 GOTO DeleteExceptions
IF ERRORLEVEL 1 GOTO AddExceptions

:AddCommonExceptions
ECHO.
ECHO *** Common Firewall Exceptions ***
ECHO.
ECHO Adding QBCFMonitorService 
netsh advfirewall firewall add rule name="Reckon Accounts - QBCFMonitorService" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBCFMonitorService.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding QBUpdate
netsh advfirewall firewall add rule name="Reckon Accounts - QBUpdate" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBUpdate\qbupdate.exe" action=allow program enable=yes dir=in profile=any
GOTO CheckUserGroup

:AddExceptions
ECHO.
ECHO *** Firewall Exceptions ***
ECHO.
ECHO Adding %YEAR% - Filemangement
netsh advfirewall firewall add rule name="Reckon Accounts %YEAR% - Filemangement" program="%INSTALL%\Intuit\%FOLDER%\FileManagement.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBDBMgr
netsh advfirewall firewall add rule name="Reckon Accounts %YEAR% - QBDBMgr" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgr.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBDBMgrN
netsh advfirewall firewall add rule name="Reckon Accounts %YEAR% - QBDBMgrN" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgrN.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBGDSPlugin
netsh advfirewall firewall add rule name="Reckon Accounts %YEAR% - QBGDSPlugin" program="%INSTALL%\Intuit\%FOLDER%\QBGDSPlugin.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBW32
netsh advfirewall firewall add rule name="Reckon Accounts %YEAR% - QBW32" program="%INSTALL%\Intuit\%FOLDER%\QBW32.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - Port:%PORT%
netsh advfirewall firewall add rule name="Reckon Accounts %YEAR% - Port" dir=in action=allow protocol=TCP localport=%PORT%
ECHO.
ECHO *** Folder Permissions ***
ECHO.
ECHO Adding Folder Permissions - user:%DATAUSER%
icacls "%DATAFOLDER%" /q /t /grant %DATAUSER%:F
GOTO AddCommonExceptions

:DeleteCommonCheck
ECHO.
ECHO *** WARNING WARNING WARNING ***
ECHO.

CHOICE /C YN /M "You are about to delete common exceptions that may be used by other versions, press N to cancel or Y to continue."

IF ERRORLEVEL 2 GOTO CheckUserGroup
IF ERRORLEVEL 1 GOTO DeleteCommonExceptions

:DeleteCommonExceptions
ECHO.
ECHO *** Common Firewall Exceptions ***
ECHO.
ECHO Deleting QBCFMonitorService
netsh advfirewall firewall delete rule name="Reckon Accounts - QBCFMonitorService" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBCFMonitorService.exe"
ECHO Deleting QBUpdate
netsh advfirewall firewall delete rule name="Reckon Accounts - QBUpdate" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBUpdate\qbupdate.exe"
GOTO CheckSharing

:DeleteExceptions
ECHO.
ECHO *** Firewall Exceptions ***
ECHO.
ECHO Deleting %YEAR% - Filemangement
netsh advfirewall firewall delete rule name="Reckon Accounts %YEAR% - Filemangement" program="%INSTALL%\Intuit\%FOLDER%\FileManagement.exe"
ECHO Deleting %YEAR% - QBDBMgr
netsh advfirewall firewall delete rule name="Reckon Accounts %YEAR% - QBDBMgr" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgr.exe"
ECHO Deleting %YEAR% - QBDBMgrN
netsh advfirewall firewall delete rule name="Reckon Accounts %YEAR% - QBDBMgrN" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgrN.exe"
ECHO Deleting %YEAR% - QBGDSPlugin
netsh advfirewall firewall delete rule name="Reckon Accounts %YEAR% - QBGDSPlugin" program="%INSTALL%\Intuit\%FOLDER%\QBGDSPlugin.exe"
ECHO Deleting %YEAR% - QBW32
netsh advfirewall firewall delete rule name="Reckon Accounts %YEAR% - QBW32" program="%INSTALL%\Intuit\%FOLDER%\QBW32.exe"
ECHO Deleting %YEAR% - QBW32
netsh advfirewall firewall delete rule name="Reckon Accounts %YEAR% - Port" protocol=TCP localport=%PORT% 
ECHO.
ECHO *** Folder Permissions ***
ECHO.
ECHO Deleting Folder Permissions - user:%DATAUSER%
icacls "%DATAFOLDER%" /q /t /remove %DATAUSER%
GOTO DeleteCommonCheck

:ChangeUserGroup
ECHO.
set /p USERGROUP="Please enter the User Group and press enter:"
ECHO.
ECHO User Group has been set to '%USERGROUP%'
ECHO.
CHOICE /C YNC /M "Is this correct? Y to continue, N to change, C to Cancel"

IF ERRORLEVEL 3 GOTO CheckUserGroup
IF ERRORLEVEL 2 GOTO ChangeUserGroup
IF ERRORLEVEL 1 GOTO CheckSharing

:CheckUserGroup
set USERGROUP=%DEFAULT_USERGROUP%
ECHO.
ECHO *** USERGROUP PERMISSIONS ***
ECHO.
ECHO The current default UserGroup '%USERGROUP%' will be used to grant rights to your data folder, using 'everyone' is NOT recommended in a Enterprise Environment(Active Directory), consult I.T. Support
ECHO.
CHOICE /C YN /M "Do you wish to change the default usergroup? (Default:%USERGROUP%) press Y to change, N to continue."

IF ERRORLEVEL 2 GOTO CheckSharing
IF ERRORLEVEL 1 GOTO ChangeUserGroup

:AddSharing
ECHO.
ECHO *** Folder Permissions ***
ECHO.
ECHO Adding Folder Permissions - user:%USERGROUP%
icacls "%DATAFOLDER%" /q /t /grant %USERGROUP%:m
GOTO Finish

:DeleteSharing
ECHO.
ECHO *** Folder Permissions ***
ECHO.
ECHO Deleting Folder Permissions - user:%USERGROUP%
icacls "%DATAFOLDER%" /q /t /remove %USERGROUP%
GOTO Finish

:CheckSharing
ECHO.
ECHO *** MULTIUSER - SHARED FOLDER PERMISSIONS ***
ECHO.
ECHO The User '%USERGROUP%' will be granted MODIFY rights to your data folder.
ECHO.

CHOICE /C YND /M "Change user '%USERGROUP%' data folder permissions, press N to cancel, Y to apply or D to Delete."

IF ERRORLEVEL 3 GOTO DeleteSharing
IF ERRORLEVEL 2 GOTO Finish
IF ERRORLEVEL 1 GOTO AddSharing

:Finish
ECHO.
ECHO *** %TITLE% - COMPLETED***
ECHO.

CHOICE /C CE /M "Press E to Exit or C to continue"

IF ERRORLEVEL 2 GOTO EOF
IF ERRORLEVEL 1 GOTO Start
