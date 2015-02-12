@echo off
rem ************************************************************
rem
rem Launch Visual C++ with the environment variables configured
rem for use with STLport.
rem
rem ************************************************************

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /I "%~1" == "" call :usage & exit /b 1
if /I "%~2" == "" call :usage & exit /b 1

:set_vars
setlocal
call SetVars.cmd "%~1" "%~2"
if errorlevel 1 exit /b 1

:launch_vc
start devenv.exe /useenv "%~3"
if errorlevel 1 (
	echo ERROR: Failed to start Visual C++
	exit /b 1
)

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [vc71 ^| vc80 ^| vc90] [STLport root folder] [solution]
echo.
echo e.g.   %~n0 vc71 D:\Libs\STLport-5.1.5
echo        %~n0 vc71 D:\Libs\STLport-5.2.0 Solution.sln
goto :eof
