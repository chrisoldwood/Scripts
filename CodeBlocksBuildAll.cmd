@echo off
rem ************************************************************
rem
rem Script to build all Code::Blocks workspaces.
rem
rem ************************************************************

:handle_help_request
if /i "%1" == "-?"     call :usage & exit /b 0
if /i "%1" == "--help" call :usage & exit /b 0

:check_args

:do_builds
for /r %%i in (*.workspace) do (
	echo ============================================================
	echo Building %%i
	echo ============================================================
	call %~dp0CodeBlocksBuild.cmd "%%i"
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
goto :eof
