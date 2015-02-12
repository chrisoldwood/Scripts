@echo off
rem ************************************************************
rem
rem Script to build all solutions for Debug and/or Release
rem targets.
rem
rem NB: See Build.cmd for notes about setting the environment
rem variables up first.
rem
rem ************************************************************

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

set build=%~1

:do_builds
for /r %%i in (*.sln) do (
	echo ============================================================
	echo Building '%%i'
	echo ============================================================
	call "%~dp0Build.cmd" %build% "%%i"
	if errorlevel 1 (
		echo.
		echo ERROR: Failed to build solution.
		exit /b 1
	)
)

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
