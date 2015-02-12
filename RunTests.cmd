@echo off
rem ************************************************************
rem
rem Script to execute all automated tests.
rem
rem ************************************************************

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1

:set_build
if /i "%~1" == "debug"	set build=Debug
if /i "%~1" == "release"	set build=Release
if /i "%build%"== "" (
echo ERROR: Invalid build type '%~1'
call :usage
exit /b 0
)

:run_tests
for /r /d %%d in (Test) do (
	if exist "%%d\%build%" (
		call :invoke_runner "%%d" "%%d\%build%\Test.exe"
		if errorlevel 1 call :show_failed & exit /b 1
	)
)

:success
call :show_passed
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [debug ^| release]
echo.
echo e.g.   %~n0 debug 
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
	echo Running: '%suite%'
	echo ============================================================
	"%runner%" -q
	echo.
)
if errorlevel 1 exit /b 1
goto :eof
