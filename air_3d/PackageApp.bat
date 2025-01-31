@echo off
set PAUSE_ERRORS=1
call bat\SetupSDK.bat
call bat\SetupApplication.bat

:menu
echo.
echo Package for target
echo.
echo Desktop:
echo  [0] normal       (air)
echo.
echo Android:
echo.
echo  [1] normal       (apk)
echo  [2] debug        (apk-debug)
echo  [3] captive      (apk-captive-runtime)
echo.
echo iOS:
echo.
echo  [4] fast test    (ipa-test-interpreter)
echo  [5] fast debug   (ipa-debug-interpreter)
echo  [6] slow test    (ipa-test)
echo  [7] slow debug   (ipa-debug)
echo  [8] "ad-hoc"     (ipa-ad-hoc)
echo  [9] App Store    (ipa-app-store)
echo.

:choice
set /P C=[Choice]: 
echo.

set PLATFORM=android
set OPTIONS=

if "%C%"=="0" set TARGET=
if "%C%"=="0" set PLATFORM=

if %C% GTR 3 set PLATFORM=ios
if %C% GTR 7 set PLATFORM=ios-dist

if "%C%"=="1" set TARGET=
if "%C%"=="2" set TARGET=-debug
if "%C%"=="2" set OPTIONS=-connect %DEBUG_IP%
if "%C%"=="3" set TARGET=-captive-runtime

if "%C%"=="4" set TARGET=-test-interpreter
if "%C%"=="5" set TARGET=-debug-interpreter
if "%C%"=="5" set OPTIONS=-connect %DEBUG_IP%
if "%C%"=="6" set TARGET=-test
if "%C%"=="7" set TARGET=-debug
if "%C%"=="7" set OPTIONS=-connect %DEBUG_IP%
if "%C%"=="8" set TARGET=-ad-hoc
if "%C%"=="9" set TARGET=-app-store

call bat\Packager.bat
pause