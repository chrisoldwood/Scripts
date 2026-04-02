@echo off
rem ***************************************************************************
rem
rem Compare the old and new format Visual C++ project files and point out any
rem missing sources files.
rem
rem ***************************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:count_args
if /i "%~1" == "" call :usage & exit /b 0

:check_tools
where /q grep
if !errorlevel! neq 0 goto :tools_missing
where /q gawk
if !errorlevel! neq 0 goto :tools_missing
where /q diff
if !errorlevel! neq 0 goto :tools_missing

set folder=%~1

if not exist "%folder%\*.vcxproj" echo ERROR: No .vcxproject project file found in "%folder%" & exit /b 1
for %%f in ("%folder%\*.vcxproj") do set vcxFile=%%f

if not exist "%folder%\*.vcproj" echo ERROR: No .vcproj project file found in "%folder%" & exit /b 1
for %%f in ("%folder%\*.vcproj") do set vcprojFile=%%f

set vcxFileList=%TEMP%\vcxFileList.txt
grep -E "(ClInclude|ClCompile|Text|None) Include=" "%vcxFile%" | gawk -F"\42" "{ print $2 }" | grep -o -E "[a-zA-Z0-9_.]+$" | sort | uniq > "%vcxFileList%" 
if %errorlevel% neq 0 exit /b 1

set vcFileList=%TEMP%\VcFileList.txt
grep -E "RelativePath=" "%vcprojFile%" | gawk -F"\42" "{ print $2 }" | grep -o -E "[a-zA-Z0-9_.]+$" | sort | uniq > "%vcFileList%"
if %errorlevel% neq 0 exit /b 1

echo %vcxFile% ^| %vcprojFile% 
diff -i "%vcxFileList%" "%vcFileList%" --side-by-side --suppress-common-lines --width 80

:success
exit /b 0

rem ***************************************************************************
rem Functions
rem ***************************************************************************

:usage
echo.
echo Usage: %~n0 ^<project folder^>
echo.
echo e.g.   %~n0 C:\Dev\Project
goto :eof

:tools_missing
echo ERROR: grep/gawk/diff not installed or on the PATH.
exit /b !errorlevel!
