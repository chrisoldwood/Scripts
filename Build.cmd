@echo off
rem ************************************************************
rem
rem Script to build a single solution for both Debug and/or
rem Release targets.
rem
rem NB: You must set the environment variables first by running
rem the SetVars script. If building with STLport you need to use
rem the STLport\SetVars script instead.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1
if /i "%~2" == "" call :usage & exit /b 1

:verify_toolchain
if /i "%TOOLCHAIN%" == "" (
	echo ERROR: Compiler environment variables not set. Run 'SetVars' first.
	exit /b 1
)

:do_debug_build
if /i "%~1" == "all"   call :build "%~2" debug
if /i "%~1" == "debug" call :build "%~2" debug
if errorlevel 1 exit /b 1

:do_release_build
if /i "%~1" == "all"     call :build "%~2" release
if /i "%~1" == "release" call :build "%~2" release
if errorlevel 1 exit /b 1

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [debug ^| release ^| all] [solution]
echo.
echo e.g.   %~n0 debug Solution.sln
echo        %~n0 all lib\project\Solution.sln
goto :eof

:build
if /i "%VC_VERSION%" == "vc71"  call :use_devenv  "%~1" "%~2"
if /i "%VC_VERSION%" == "vc80"  call :use_vcbuild "%~1" "%~2"
if /i "%VC_VERSION%" == "vc90"  call :use_vcbuild "%~1" "%~2"
if /i "%VC_VERSION%" == "vc100" (
        if /i "%VC_EDITION%" == "retail" (
                call :use_devenv "%~1" "%~2"
        ) else (
                call :use_vcexpress "%~1" "%~2"
        )
)
if /i "%VC_VERSION%" == "vc110" call :use_devenv  "%~1" "%~2"
if /i "%VC_VERSION%" == "vc140" call :use_devenv  "%~1" "%~2"
if /i "%VC_VERSION%" == "vc150" call :use_devenv  "%~1" "%~2"
if /i "%VC_VERSION%" == "vc160" call :use_devenv  "%~1" "%~2"
if /i "%VC_VERSION%" == "vc170" call :use_devenv  "%~1" "%~2"
if errorlevel 1 exit /b 1
goto :eof

:use_devenv
devenv /nologo /useenv "%~1" /build "%~2"
if errorlevel 1 exit /b 1
goto :eof

:use_vcbuild
vcbuild /nologo /useenv "%~1" "%~2|%VC_PLATFORM%"
if errorlevel 1 exit /b 1
goto :eof

:use_vcexpress
vcexpress "%~1" /useenv /build "%~2|%VC_PLATFORM%"
if errorlevel 1 exit /b 1
goto :eof
