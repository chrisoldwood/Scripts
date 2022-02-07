@echo off
rem ************************************************************
rem
rem Script to create a ZIP deployment package.
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
echo Usage: %~n0 [debug ^| release ^| all] [Solution folder]
echo.
echo e.g.   %~n0 all project
goto :eof

:build
pushd "%~1"

set build=%~2
set zipfile=%build%\%~n1.zip
set filelist=PkgList.%build%.txt

if exist "%zipfile%" del "%zipfile%"
if errorlevel 1 popd & exit /b 1

7z a -tzip -bd %zipfile% @%filelist%
if errorlevel 1 popd & exit /b 1

popd
goto :eof
