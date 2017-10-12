@echo off
rem ************************************************************
rem
rem Script to run the configuration script for the specified
rem version of the Visual C++ compiler.
rem
rem VC++  7.1: "%VS71COMNTOOLS%\vsvars32.bat"
rem VC++  8.0: "%VS80COMNTOOLS%\vsvars32.bat"
rem VC++  9.0: "%VS90COMNTOOLS%\vsvars32.bat"
rem VC++ 10.0: "%VS100COMNTOOLS%\vsvars32.bat"
rem VC++ 11.0: "%VS110COMNTOOLS%\vsvars32.bat"
rem VC++ 14.0: "%VS140COMNTOOLS%\vsvars32.bat"
rem VC++ 15.0: "vswhere + vsvars32.bat"
rem
rem The --reset switch ensures that the variables are cleaned
rem out first to provide a tighter sandbox. 
rem
rem ************************************************************

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:count_args
if /i "%~1" == "" call :usage & exit /b 0

:apply_defaults
set TOOLCHAIN=%~1
if /i "%TOOLCHAIN:~-4,1%" == "-" goto :tokenise_toolchain
set TOOLCHAIN=%~1-x86

:tokenise_toolchain
for /f "tokens=1,2 delims=-" %%i in ("%TOOLCHAIN%") do (
	set compiler=%%i
	set platform=%%j
)

:reset_vars
if /i not "%~2" == "--reset" (
    if defined INCLUDE echo WARNING: INCLUDE variable already defined 
    if defined LIB echo WARNING: LIB variable already defined 
    goto :detect_platform 
)

set INCLUDE=
set LIB=
set PATH=^
%SystemRoot%\system32\WindowsPowerShell\v1.0;^
%SystemRoot%\system32;^
%SystemRoot%

:detect_platform
if /i "%platform%" == "x86" GOTO :set_x86_platform
if /i "%platform%" == "x64" GOTO :set_x64_platform
echo ERROR: Invalid platform specified '%platform%'
call :usage
exit /b 1

:set_x86_platform
set VC_PLATFORM=Win32
goto :detect_compiler

:set_x64_platform
set VC_PLATFORM=x64
goto :detect_compiler

:detect_compiler
if /i "%compiler%" == "vc71"  goto :set_vc71_compiler
if /i "%compiler%" == "vc80"  goto :set_vc80_compiler
if /i "%compiler%" == "vc90"  goto :set_vc90_compiler
if /i "%compiler%" == "vc100" goto :set_vc100_compiler
if /i "%compiler%" == "vc110" goto :set_vc110_compiler
if /i "%compiler%" == "vc140" goto :set_vc140_compiler
if /i "%compiler%" == "vc150" goto :set_vc150_compiler
echo ERROR: Invalid compiler specified '%compiler%'
call :usage
exit /b 1

:set_vc71_compiler
set VC_VERSION=vc71
set VS_COMNTOOLS=%VS71COMNTOOLS%
if not defined VS71COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (VS71COMNTOOLS not defined)  & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc7\bin\vcvars32.bat"
if /i "%platform%" == "x64" call :unsupported_compiler %TOOLCHAIN% & exit /b 1
if errorlevel 1 exit /b 1
goto :success

:set_vc80_compiler
set VC_VERSION=vc80
set VS_COMNTOOLS=%VS80COMNTOOLS%
if not defined VS80COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (VS80COMNTOOLS not defined)  & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\vcvars32.bat"
if /i "%platform%" == "x64" call :unsupported_compiler %TOOLCHAIN% & exit /b 1
if errorlevel 1 exit /b 1
goto :success

:set_vc90_compiler
set VC_VERSION=vc90
set VS_COMNTOOLS=%VS90COMNTOOLS%
if not defined VS90COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (VS90COMNTOOLS not defined)  & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\vcvars32.bat"
if /i "%platform%" == "x64" (
	if exist "%VS_COMNTOOLS%..\..\vc\bin\x86_amd64\vcvarsx86_amd64.bat" (
		call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\x86_amd64\vcvarsx86_amd64.bat"
	) else (
		call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\vcvarsx86_amd64.bat"
	)
)
if errorlevel 1 exit /b 1
goto :success

:set_vc100_compiler
set VC_VERSION=vc100
set VS_COMNTOOLS=%VS100COMNTOOLS%
if not defined VS100COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (VS100COMNTOOLS not defined)  & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\vcvars32.bat"
if /i "%platform%" == "x64" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\x86_amd64\vcvarsx86_amd64.bat"
if errorlevel 1 exit /b 1
goto :success

:set_vc110_compiler
set VC_VERSION=vc110
set VS_COMNTOOLS=%VS110COMNTOOLS%
if not defined VS110COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (VS110COMNTOOLS not defined)  & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\vcvars32.bat"
if /i "%platform%" == "x64" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\x86_amd64\vcvarsx86_amd64.bat"
if errorlevel 1 exit /b 1
goto :success

:set_vc140_compiler
set VC_VERSION=vc140
set VS_COMNTOOLS=%VS140COMNTOOLS%
if not defined VS140COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (VS140COMNTOOLS not defined)  & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\vcvars32.bat"
if /i "%platform%" == "x64" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\bin\x86_amd64\vcvarsx86_amd64.bat"
if errorlevel 1 exit /b 1
goto :success

:set_vc150_compiler
set VC_VERSION=vc150
set vswhereFolder=%ProgramFiles%\Microsoft Visual Studio\Installer
if not exist "%vswhereFolder%\vswhere.exe" set vswhereFolder=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer
if not exist "%vswhereFolder%\vswhere.exe" echo ERROR: vswhere.exe not installed & exit /b 1
pushd %vswhereFolder%
for /f "usebackq tokens=1* delims=;" %%i in (`vswhere.exe -version "[15,16.0)" -property installationPath`) do set VS150COMNTOOLS=%%i\Common7\Tools\
popd
set VS_COMNTOOLS=%VS150COMNTOOLS%
if not defined VS150COMNTOOLS echo ERROR: %VC_VERSION% compiler not installed (vswhere did not find it) & exit /b 1
if /i "%platform%" == "x86" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\Auxiliary\Build\vcvars32.bat"
if /i "%platform%" == "x64" call :configure_compiler "%VS_COMNTOOLS%..\..\vc\Auxiliary\Build\vcvarsx86_amd64.bat"
goto :success

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:configure_compiler
if not exist "%~1" (
	echo ERROR: The compiler configuration script does not exist "%~1"
	exit /b 1
)

echo Invoking: %~1
call "%~1"
if errorlevel 1 (
	echo ERROR: Failed to configure the compiler using script "%~1"
	exit /b 1
)

cl.exe 2>&1 | findstr /i /c:version

if exist "%VS_COMNTOOLS%..\IDE\devenv.exe" (
set VC_EDITION=retail
) else (
set VC_EDITION=express
)
goto :eof

:unsupported_compiler
echo ERROR: Unsupported compiler "%~1"
exit /b 1

:usage
echo.
echo Usage: %~n0 [vc71 ^| vc80 ^| vc90 ^| vc100 ^| vc110 ^| vc140 ^| vc150] [-x86 ^| -x64] [--reset]
echo.
echo e.g.   %~n0 vc71     (implies -x86)
echo        %~n0 vc80-x86
echo        %~n0 vc80-x64 --reset
echo.
echo Note: vc71=vs2003, vc80=vs2005, vc90=vs2008, vc100=vs2010, vc110=vs2012, vc140=vs2015, vc150=vs2017
goto :eof

:display_vars
echo TOOLCHAIN=%TOOLCHAIN%
echo compiler=%compiler%
echo platform=%platform%
echo VC_VERSION=%VC_VERSION%
echo VC_PLATFORM=%VC_PLATFORM%
goto :eof
