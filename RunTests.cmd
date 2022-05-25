@echo off
rem ************************************************************
rem
rem Script to execute all automated tests.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1

:verify_toolchain
if /i "%TOOLCHAIN%" == "" (
	echo ERROR: Compiler environment variables not set. Run 'SetVars' first.
	exit /b 1
)

:check_build
if /i "%~1" == "all"		goto :do_debug_build
if /i "%~1" == "debug"		goto :do_debug_build
if /i "%~1" == "release"	goto :do_release_build
echo ERROR: Invalid build type '%~1'
call :usage
exit /b 1

:do_debug_build
if /i "%~1" == "all"   call :run_tests debug
if /i "%~1" == "debug" call :run_tests debug
if errorlevel 1 exit /b 1

:do_release_build
if /i "%~1" == "all"     call :run_tests release
if /i "%~1" == "release" call :run_tests release
if errorlevel 1 exit /b 1

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [debug ^| release ^| all]
echo.
echo e.g.   %~n0 debug 
goto :eof

:run_tests
set "build=%~1"
for /r /d %%d in (Test) do (
	set "folder=%%d\%build%"
	if exist "!folder!" (
		if exist "!folder!\%VC_PLATFORM%" set "folder=!folder!\%VC_PLATFORM%"
		call :invoke_runner "%%d" "!folder!\Test.exe"
		if errorlevel 1 call :show_failed & exit /b 1
	)
)

call :show_passed
goto :eof

:show_passed
echo ------------------------------------------------------------
echo The suite of tests passed
echo ------------------------------------------------------------
goto :eof

:show_failed
echo ************************************************************
echo The suite of tests FAILED
echo ************************************************************
goto :eof

:invoke_runner
set suite=%~1
set runner=%~2
if exist "%runner%" (
	echo ============================================================
	echo Running: '%suite%' ^(%VC_PLATFORM%^|%build%^)
	echo ============================================================
	"%runner%" -q
	echo.
)
if errorlevel 1 exit /b 1
goto :eof
