@echo off
rem ***************************************************************************
rem
rem Script to build a CodeBlocks workspace
rem
rem Note: The CodeBlocks build is not command line based and so it returns
rem immediately. This is also the reason why we leave the build window open,
rem because otherwise there is no build output.
rem
rem ***************************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1

set "codeBlocksProgram=%ProgramFiles%\CodeBlocks\codeblocks.exe"

if not defined "ProgramFiles(x86)" goto :check_installed
set "codeBlocksProgram=%ProgramFiles(x86)%\CodeBlocks\codeblocks.exe"

:check_installed
if not exist "%codeBlocksProgram%" (
	echo ERROR: CodeBlocks program not installed under "(Program Files x86/x64)\CodeBlocks\codeblocks.exe"
	exit /b 1
)

"%codeBlocksProgram%" --build "%~1" --no-batch-window-close
if errorlevel 1 (
	echo ERROR: Build failed.
	exit /b 1
)

:success
exit /b 0

rem ***************************************************************************
rem Functions
rem ***************************************************************************

:usage
echo.
echo Usage: %~n0 [solution]
echo.
echo e.g.   %~n0 lib\project\Solution.workspace
goto :eof
