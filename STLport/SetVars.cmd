@echo off
rem ************************************************************
rem
rem Setup the environment variables for STLport. We have to
rem ensure that the STLport include path precedes the Visual C++
rem one.
rem
rem ************************************************************

:handle_help_request
if /i "%1" == "-?"     call :usage & exit /b 0
if /i "%1" == "--help" call :usage & exit /b 0

:check_args
if /I "%1" == "" call :usage & exit /b 1
if /I "%2" == "" call :usage & exit /b 1

:set_vars
call ..\SetVars.cmd %1
if errorlevel 1 exit /b 1

:inject_stlport_paths
set INCLUDE=%2\stlport;%INCLUDE%
set LIB=%2\lib;%LIB%
set PATH=%PATH%;%2\bin;

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [vc71 ^| vc80 ^| vc90] [STLport root folder]
echo.
echo e.g.   %~n0 vc71 D:\Libs\STLport-5.1.5
goto :eof
