::QuickBooks Installation - Firewall Exceptions & User Permissions (QB-INSTALLPREP.bat)
::Place QB-INSTALLPREP.bat file in your datafile (QBW) location.
@ECHO OFF
SETLOCAL
CLS
::Usergroup Default Setting (change if required)
:: example(set DEFAULT_USERGROUP=QuickBooks_Users) will set folder permissions of the 'QuickBooks_Users' group to modify.
set DEFAULT_USERGROUP=everyone

::DONT NOT CHANGE
set TITLE=QuickBooks Installation
set DATAFOLDER=%~dp0
IF %DATAFOLDER:~-1%==\ SET DATAFOLDER=%DATAFOLDER:~0,-1%
GOTO Start
:Start
ECHO *** %TITLE% ***
ECHO *** Firewall Exceptions and Folder Permissions ***
ECHO.
ECHO 1.QuickBooks 2008/09
ECHO 2.QuickBooks 2009/10
ECHO 3.QuickBooks 2010/11
ECHO 4.QuickBooks 2011/12
ECHO 5.QuickBooks 2012/13
ECHO. 

CHOICE /C 12345 /M "Select a Version:"

IF ERRORLEVEL 5 GOTO 2012
IF ERRORLEVEL 4 GOTO 2011
IF ERRORLEVEL 3 GOTO 2010
IF ERRORLEVEL 2 GOTO 2009
IF ERRORLEVEL 1 GOTO 2008

:2008
set YEAR=2008/09
set PORT=10172
set FOLDER=QuickBooks 2008-09
set DATAUSER=QBDataServiceUser17
goto CheckOS

:2009
set YEAR=2009/10
set PORT=10172
set FOLDER=QuickBooks 2009-10
set DATAUSER=QBDataServiceUser18
goto CheckOS

:2010
set YEAR=2010/11
set PORT=10173
set FOLDER=QuickBooks 2010-11
set DATAUSER=QBDataServiceUser19
goto CheckOS

:2011
set YEAR=2011/12
set PORT=10174
set FOLDER=QuickBooks 2011-12
set DATAUSER=QBDataServiceUser20
goto CheckOS

:2012
set YEAR=2012/13
set PORT=10175
set FOLDER=QuickBooks 2012-13
set DATAUSER=QBDataServiceUser21
goto CheckOS

:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" ( GOTO 64Bit ) ELSE ( GOTO 32Bit )

:32Bit
set INSTALL=%PROGRAMFILES%
goto Action

:64Bit
set INSTALL=%PROGRAMFILES(X86)%
goto Action

:Action
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
netsh advfirewall firewall add rule name="QuickBooks - QBCFMonitorService" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBCFMonitorService.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding QBUpdate
netsh advfirewall firewall add rule name="QuickBooks - QBUpdate" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBUpdate\qbupdate.exe" action=allow program enable=yes dir=in profile=any
GOTO CheckUserGroup

:AddExceptions
ECHO.
ECHO *** Firewall Exceptions ***
ECHO.
ECHO Adding %YEAR% - Filemangement
netsh advfirewall firewall add rule name="QuickBooks %YEAR% - Filemangement" program="%INSTALL%\Intuit\%FOLDER%\FileManagement.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBDBMgr
netsh advfirewall firewall add rule name="QuickBooks %YEAR% - QBDBMgr" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgr.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBDBMgrN
netsh advfirewall firewall add rule name="QuickBooks %YEAR% - QBDBMgrN" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgrN.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBGDSPlugin
netsh advfirewall firewall add rule name="QuickBooks %YEAR% - QBGDSPlugin" program="%INSTALL%\Intuit\%FOLDER%\QBGDSPlugin.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - QBW32
netsh advfirewall firewall add rule name="QuickBooks %YEAR% - QBW32" program="%INSTALL%\Intuit\%FOLDER%\QBW32.exe" action=allow program enable=yes dir=in profile=any
ECHO Adding %YEAR% - Port:%PORT%
netsh advfirewall firewall add rule name="QuickBooks %YEAR% - Port" dir=in action=allow protocol=TCP localport=%PORT%
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
netsh advfirewall firewall delete rule name="QuickBooks - QBCFMonitorService" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBCFMonitorService.exe"
ECHO Deleting QBUpdate
netsh advfirewall firewall delete rule name="QuickBooks - QBUpdate" program="%INSTALL%\Common Files\Intuit\QuickBooks\QBUpdate\qbupdate.exe"
GOTO CheckSharing

:DeleteExceptions
ECHO.
ECHO *** Firewall Exceptions ***
ECHO.
ECHO Deleting %YEAR% - Filemangement
netsh advfirewall firewall delete rule name="QuickBooks %YEAR% - Filemangement" program="%INSTALL%\Intuit\%FOLDER%\FileManagement.exe"
ECHO Deleting %YEAR% - QBDBMgr
netsh advfirewall firewall delete rule name="QuickBooks %YEAR% - QBDBMgr" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgr.exe"
ECHO Deleting %YEAR% - QBDBMgrN
netsh advfirewall firewall delete rule name="QuickBooks %YEAR% - QBDBMgrN" program="%INSTALL%\Intuit\%FOLDER%\QBDBMgrN.exe"
ECHO Deleting %YEAR% - QBGDSPlugin
netsh advfirewall firewall delete rule name="QuickBooks %YEAR% - QBGDSPlugin" program="%INSTALL%\Intuit\%FOLDER%\QBGDSPlugin.exe"
ECHO Deleting %YEAR% - QBW32
netsh advfirewall firewall delete rule name="QuickBooks %YEAR% - QBW32" program="%INSTALL%\Intuit\%FOLDER%\QBW32.exe"
ECHO Deleting %YEAR% - QBW32
netsh advfirewall firewall delete rule name="QuickBooks %YEAR% - Port" protocol=TCP localport=%PORT% 
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
