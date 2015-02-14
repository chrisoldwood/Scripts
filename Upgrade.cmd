@echo off
rem ************************************************************
rem
rem Script to upgrade a single project or solution file to a
rem newer version of Visual Studio. Due to the Express versions
rem not shipping with a full version of DEVENV the Solution
rem files have to be upgraded using the IDE.
rem
rem NB: You must set the environment variables first by running
rem the SetVars script.
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

echo Upgrading '%~1'...

:do_upgrade
if /i "%VC_EDITION%" == "retail" (
devenv /upgrade "%~1"
if errorlevel 1 exit /b 1
) else (
vcexpress "%~1"
if errorlevel 1 exit /b 1
)

:do_cleanup
echo.
echo Cleaning up...
if exist "%~dp1..\..\..\Lib" (
del /s %~dp1..\..\..\Lib\*.vcproj.*.*.old 2> nul
del /s %~dp1..\..\..\Lib\*.vcproj.*.*.user 2> nul
)
if exist "%~dp1..\Lib" (
del /s %~dp1..\Lib\*.vcproj.*.*.old 2> nul
del /s %~dp1..\Lib\*.vcproj.*.*.user 2> nul
)
del %~dpn1.sln.old 2> nul
del %~dp1Backup\%~n1.sln 2> nul
del /ah %~dp1Backup\%~n1.suo 2> nul
del /s %~dp1\*.vcproj.*.*.old 2> nul
del /s %~dp1\*.vcproj.*.*.user 2> nul
del /s %~dp1\UpgradeLog*.htm 2> nul
del /s %~dp1\UpgradeLog*.XML 2> nul
for /d %%d in (%~dp1Backup\*.*) do rmdir /q %%d 2>nul
rmdir /q %~dp1Backup 2> nul
rmdir /s /q %~dp1\_UpgradeReport_Files 2> nul

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [solution]
echo.
echo e.g.   %~n0 lib\project\Solution.sln
goto :eof
