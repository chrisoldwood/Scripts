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

:handle_help_request
if /i "%1" == "-?"     call :usage & exit /b 0
if /i "%1" == "--help" call :usage & exit /b 0

:check_args
if /I "%1" == "" call :usage & exit /b 1

:verify_toolchain
if /i "%TOOLCHAIN%" == "" (
	echo ERROR: Compiler environment variables not set. Run 'SetVars' first.
	exit /b 1
)

echo Upgrading %1...

attrib -r /s Lib\*.vcproj
attrib -r %~dpn1.sln  
attrib -r %~dpn1.vcproj  

:do_upgrade
if /i "%VC_EDITION%" == "retail" (
devenv /upgrade %1
if errorlevel 1 exit /b 1
) else (
vcexpress %1
if errorlevel 1 exit /b 1
)

:do_cleanup
del /s lib\*.vcproj.*.*.old 2> nul
del %~dpn1.sln.old 2> nul
del /s %~dp1\*.vcproj.*.*.old 2> nul
del /s %~dp1\UpgradeLog*.XML 2> nul
rd /s /q %~dp1\_UpgradeReport_Files 2> nul

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
