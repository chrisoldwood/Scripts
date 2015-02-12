@echo off
rem ************************************************************
rem
rem Script to build a Code::Blocks workspace
rem
rem NB: The Code::Blocks build is not command line based and so
rem it returns immediately. This is also the reason why we leave
rem the build window open because otherwise there is no build
rem output.
rem
rem ************************************************************

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1

set codeBlocksProgram=c:\Program Files\CodeBlocks\codeblocks.exe

if not exist "%codeBlocksProgram%" (
	echo ERROR: Code::Blocks program not installed as '%codeBlocksProgram%'
	exit /b 1
)

"%codeBlocksProgram%" --build "%~1" --no-batch-window-close
if errorlevel 1 (
	echo ERROR: Build failed.
	exit /b 1
)

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [solution]
echo.
echo e.g.   %~n0 lib\project\Solution.workspace
goto :eof
