@echo off
rem ************************************************************
rem
rem Script to build an MSI using the WiX toolkit.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1
if /i "%~2" == "" call :usage & exit /b 1

:do_debug_build
if /i "%~1" == "all"   call :build "%~2" Debug
if /i "%~1" == "debug" call :build "%~2" Debug
if errorlevel 1 exit /b 1

:do_release_build
if /i "%~1" == "all"     call :build "%~2" Release
if /i "%~1" == "release" call :build "%~2" Release
if errorlevel 1 exit /b 1

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [debug ^| release ^| all] [WiX script]
echo.
echo e.g.   %~n0 all project\Setup.wxs
goto :eof

:build
where /q candle
if !errorlevel! neq 0 goto :wix_missing
where /q light
if !errorlevel! neq 0 goto :wix_missing

pushd "%~dp1."

if not defined VC_PLATFORM (
    echo WARNING: VC_PLATFORM is not defined.
)

set build=%~2
set platform=%VC_PLATFORM%
set input=%~nx1
set locfile=%~n1.wxl
set objfile=%build%\%~n1.wixobj
set msifile=%build%\%~n1.msi

candle %input% -out %objfile% -nologo -wx
if errorlevel 1 popd & exit /b 1

light %objfile% -out %msifile% -nologo -wx -ext WixUIExtension -cultures:en-us -loc %locfile%
if errorlevel 1 popd & exit /b 1

popd
goto :eof

:wix_missing
echo ERROR: WiX not installed or on the PATH.
echo You can install it with 'choco install -y Wix35'.
echo Note: you also need to manually update the PATH.
exit /b !errorlevel!
