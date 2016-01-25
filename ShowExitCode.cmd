@echo off
rem ************************************************************
rem
rem Runs the command described the scripts arguments and then
rem displays the process exit code.
rem
rem ************************************************************
call %*
echo.
echo ExitCode=[%ERRORLEVEL%]
