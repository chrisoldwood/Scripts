@echo off
rem ************************************************************
rem
rem Compare the Visual C++ and CodeBlocks project files and
rem point anyout  mismatches.
rem
rem ************************************************************
setlocal

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:count_args
if /i "%~1" == "" call :usage & exit /b 0

set folder=%~1
 
if not exist "%folder%\*.cbp" echo ERROR: No .cbp project file found in "%folder%" & exit /b 1
for %%f in ("%folder%\*.cbp") do set cbpFile=%%f

if not exist "%folder%\*.vcproj" echo ERROR: No .vcproj project file found in "%folder%" & exit /b 1
for %%f in ("%folder%\*.vcproj") do set vcprojFile=%%f

set cbFileList=%TEMP%\CbFileList.txt
grep -E "Unit filename" "%cbpFile%" | gawk -F"\42" "{ print $2 }" | sed "s/\\//\\\\/g" | sed "s/\\.*\\.\\\\//" | sort | uniq > "%cbFileList%" 
if %errorlevel% neq 0 exit /b 1

set vcFileList=%TEMP%\VcFileList.txt
grep -E "RelativePath=" "%vcprojFile%" | gawk -F"\42" "{ print $2 }" | sed "s/\\.*\\.\\\\//" | sort | uniq > "%vcFileList%"
if %errorlevel% neq 0 exit /b 1

echo %cbpFile% ^| %vcprojFile% 
diff -i "%cbFileList%" "%vcFileList%" --side-by-side --suppress-common-lines --width 80

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
