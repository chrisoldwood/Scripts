@echo off
rem ************************************************************
rem
rem Downgrade a solution and projects to Visual C++ 7.1 so they
rem can be build for the Windows 95 lineage.
rem
rem ************************************************************
setlocal

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:count_args
if /i "%~1" == "" call :usage & exit /b 0

set folder=%~1

for /r "%folder%" %%f in (*.vcproj) do (
	echo Downgrading "%%f"
	sed -i "s/CharacterSet=\"1\"/CharacterSet=\"2\"/g" "%%f"
	sed -i "s/Version=\"9.00\"/Version=\"7.10\"/g" "%%f"
	sed -i "s/Name=\"VCCLCompilerTool\"/Name=\"VCCLCompilerTool\" AdditionalOptions=\"\/EHa\"/g" "%%f"
	sed -i "s/ExceptionHandling=\"2\"/ExceptionHandling=\"FALSE\"/g" "%%f"
)

for /r "%folder%" %%f in (*.sln) do (
	echo Downgrading "%%f"
	sed -i "s/Version 10.00/Version 8.00/g" "%%f"
	sed -i "s/# Visual Studio 2008//g" "%%f"
)

del sed* 1>nul 2>nul

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 ^<project folder^>
echo.
echo e.g.   %~n0 C:\Dev\Project
goto :eof
