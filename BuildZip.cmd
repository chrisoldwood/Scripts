@echo off
rem ************************************************************
rem
rem Script to create a ZIP deployment package.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args_exist
if /i "%~1" == "" call :usage & exit /b 1
if /i "%~2" == "" call :usage & exit /b 1
if /i "%~3" == "" call :usage & exit /b 1

:check_build
if /i "%~1" == "all"     goto :check_platform
if /i "%~1" == "debug"   goto :check_platform
if /i "%~1" == "release" goto :check_platform
call :usage & exit /b 1

:check_platform
if /i "%~2" == "all"   goto :args_valid
if /i "%~2" == "win32" goto :args_valid
if /i "%~2" == "x64"   goto :args_valid
call :usage & exit /b 1

:args_valid
where /q 7z
if !errorlevel! neq 0 goto :7zip_missing

call :decode_build %*

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [debug ^| release ^| all] [Win32 ^| x64 ^| all] [Solution folder]
echo.
echo e.g.   %~n0 all all project
goto :eof

:decode_build
if /i "%~1" == "all"   call :decode_platform Debug "%~2" "%~3" || exit /b
if /i "%~1" == "debug" call :decode_platform Debug "%~2" "%~3" || exit /b

if /i "%~1" == "all"     call :decode_platform Release "%~2" "%~3" || exit /b
if /i "%~1" == "release" call :decode_platform Release "%~2" "%~3" || exit /b
goto :eof

:decode_platform
if /i "%~2" == "all"   call :build "%~1" Win32 "%~3" || exit /b
if /i "%~2" == "Win32" call :build "%~1" Win32 "%~3" || exit /b

if /i "%~2" == "all"   call :build "%~1" x64 "%~3" || exit /b
if /i "%~2" == "x64"   call :build "%~1" x64 "%~3" || exit /b
goto :eof

:build
if /i "%~n3" == "" (
    echo ERROR: Empty solution folder name. Trailing backslash?
    exit /b 1
)

set "pkglist=%~3\PkgList.txt"
if not exist %pkglist% (
    echo ERROR: Package list "%pkglist%" is missing!
    exit /b 1
)

pushd "%~3" || exit /b
call :build_zip %*
goto :eof

:build_zip
set build=%~1
set platform=%~2
set folder=%~n3
set zipdir=%build%\%platform%
set zipfile=%zipdir%\%folder%.zip
set pkglist=PkgList.txt
set filelist=%zipdir%\FileList.txt

if not exist "%zipdir%" mkdir "%zipdir%" || exit /b
if exist "%filelist%" del "%filelist%" || exit /b
if exist "%zipfile%" del "%zipfile%" || exit /b

for /f %%l in (%pkglist%) do (
    set "file=%%l"
    set "file=!file:${BUILD}=%build%!"
    set "file=!file:${PLATFORM}=%platform%!"
    if not exist "!file!" (
        echo ERROR: Package file missing: "!file!"
        exit /b 1
    )
    echo !file!>>"%filelist%" || exit /b
)

7z a -tzip -bd %zipfile% @%filelist% || exit /b

popd
goto :eof

:7zip_missing
echo ERROR: 7z not installed or on the PATH.
echo You can install it with 'choco install -y 7zip'.
exit /b !errorlevel!
