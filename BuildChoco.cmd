@echo off
rem ************************************************************
rem
rem Build a Chocolately package.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1

:build
pushd "%~dp1."

if not exist "bin" (
	mkdir "bin"
	if !errorlevel! neq 0 popd & exit /b 1
)

for /f %%f in (PkgList.txt) do (
	if not exist "%%f" (
		echo ERROR: Package artefact "%%f" not found
		popd & exit /b 1
	)
	echo Copying artefact "%%f"
	copy /y "%%f" "bin\." 1>nul
)

choco pack
if %errorlevel% neq 0 popd & exit /b 1

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 ^<.nuspec file^>
echo.
echo e.g.   %~n0 project\Chocolatey\project.nuspec
goto :eof
