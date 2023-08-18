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
where /q choco
if !errorlevel! neq 0 goto :choco_missing

pushd "%~dp1."

if not exist "bin" (
	mkdir "bin"
	if !errorlevel! neq 0 popd & exit /b 1
)

set "pkglist=PkgList.txt"
if not exist "%pkglist%" (
    echo ERROR: Package list "%pkglist%" is missing!
    exit /b 1
)

for /f %%f in (%pkglist%) do (
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

:choco_missing
echo ERROR: Chocolatey not installed or on the PATH.
echo See https://chocolatey.org/install for instructions.
exit /b !errorlevel!
