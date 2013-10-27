@echo off
rem ************************************************************
rem
rem Script to build an MSI using the WiX toolkit.
rem
rem NB: You must set the environment variables first by running
rem the SetVars script.
rem
rem ************************************************************

:handle_help_request
if /i "%1" == "-?"     call :usage & exit /b 0
if /i "%1" == "--help" call :usage & exit /b 0

:check_args
if /I "%1" == "" call :usage & exit /b 1
if /I "%2" == "" call :usage & exit /b 1

:verify_toolchain
if /i "%TOOLCHAIN%" == "" (
	echo ERROR: Compiler environment variables not set. Run 'SetVars' first.
	exit /b 1
)

:do_debug_build
if /i "%1" == "all"   call :build %2 Debug
if /i "%1" == "debug" call :build %2 Debug
if errorlevel 1 exit /b 1

:do_release_build
if /I "%1" == "all"     call :build %2 Release
if /I "%1" == "release" call :build %2 Release
if errorlevel 1 exit /b 1

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [debug ^| release ^| all] [solution]
echo.
echo e.g.   %~n0 all project\Setup.wxs
goto :eof

:build
pushd %~dp1.

set build=%2
set input=%~nx1
set locfile=%~n1.wxl
set objfile=%2\%~n1.wixobj
set msifile=%2\%~n1.msi

candle %input% -out %objfile% -nologo -wx
if errorlevel 1 popd & exit /b 1

light %objfile% -out %msifile% -nologo -wx -ext WixUIExtension -cultures:en-us -loc %locfile%
if errorlevel 1 popd & exit /b 1

popd
goto :eof
