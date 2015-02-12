@echo off
rem ************************************************************
rem
rem Script to upgrade all VC++ Project files to a newer version
rem of Visual C++. 
rem
rem NB: You must set the environment variables first by running
rem the SetVars script.
rem
rem ************************************************************

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:verify_toolchain
if /i "%TOOLCHAIN%" == "" (
	echo ERROR: Compiler environment variables not set. Run 'SetVars' first.
	exit /b 1
)

:upgrade_solutions
for /r %%i in (*.sln) do (
	call %~dp0Upgrade.cmd %%i
	if errorlevel 1 exit /b 1
)

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0
echo.
echo e.g.   %~n0
goto :eof
