@echo off
rem ************************************************************
rem
rem Configure and build STLport for Visual C++.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /I "%~1" == "" call :usage & exit /b 1
if /I "%~2" == "" call :usage & exit /b 1

:set_vars
setlocal
call "SetVars.cmd" "%~1" "%~2"
if errorlevel 1 exit /b 1

:set_compiler
if /i "%~1" == "vc71" set compiler=msvc71
if /i "%~1" == "vc80" set compiler=msvc8
if /i "%~1" == "vc90" set compiler=msvc9

if /i "%compiler%" == "" (
echo ERROR: Unsupported compiler '%~1'
call :usage
exit /b 1
)

pushd "%~2"
if errorlevel 1 (
	echo ERROR: Failed to change to STLport folder '%~2'
	exit /b 1
)

:configure
if exist "build\lib\configure.bat" (
	cd build\lib
	if errorlevel 1 call :cleanup & exit /b 1

	call configure --compiler %compiler% --extra-cxxflag /Zc:wchar_t --extra-cxxflag /Zc:forScope
	if errorlevel 1 call :cleanup & exit /b 1
) else (
	call configure %compiler% --extra-cxxflag /Zc:wchar_t --extra-cxxflag /Zc:forScope
	rem if errorlevel 1 call :cleanup & exit /b 1

	cd build\lib
	if errorlevel 1 call :cleanup & exit /b 1
)

:clean
rd /s /q obj 2> nul
rd /s /q ..\..\bin 2> nul
rd /s /q ..\..\lib 2> nul

:build
nmake /f msvc.mak
if errorlevel 1 call :cleanup & exit /b 1

nmake /f msvc.mak install
if errorlevel 1 call :cleanup & exit /b 1

call :cleanup

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

:cleanup
popd
goto :eof
