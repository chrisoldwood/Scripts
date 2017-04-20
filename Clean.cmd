@echo off
rem ********************************************************************************
rem
rem Remove virtually all temporary build artefacts as Visual Studio leaves plenty of
rem detritus lying around. We leave the .suo and .user files around unless --all is
rem specified as its often desirable to clean the workspace but leave some
rem temporary settings, like breakpoints, in place.
rem
rem This script sits between "devenv /clean" and "git clean -fdx".
rem
rem ********************************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:do_clean
echo Removing VC++ intermediate files...

del /s /f *.pch 2> nul
del /s /f *.ipch 2> nul
del /s /f *.sbr 2> nul
del /s /f *.obj 2> nul
del /s /f *.res 2> nul
del /s /f *.tlh 2> nul
del /s /f *.tli 2> nul
del /s /f *.tlb 2> nul
del /s /f *_p.c 2> nul
del /s /f *_h.h 2> nul
del /s /f *_i.c 2> nul
del /s /f dlldata.c 2> nul
del /s /f BuildLog.htm 2> nul
del /s /f *.manifest 2> nul
del /s /f mt.dep 2> nul
del /s /f *.tlog 2> nul
del /s /f *ResolveAssemblyReference.cache 2> nul
del /s /f *.lastbuildstate 2> nul
del /s /f *.unsuccessfulbuild 2> nul
del /s /f *_manifest.rc 2> nul

echo Removing VC++ target files...

del /s /f *.pdb 2> nul
del /s /f *.idb 2> nul
del /s /f *.ilk 2> nul
del /s /f *.exe 2> nul
del /s /f *.dll 2> nul
del /s /f *.lib 2> nul
del /s /f *.plg 2> nul
del /s /f *.map 2> nul
del /s /f *.exp 2> nul

echo Removing VC++ workspace files...

del /s /f *.ncb 2> nul
del /s /f *.sdf 2> nul
del /s /f *.opt 2> nul
del /s /f *.aps 2> nul
del /s /f *.bsc 2> nul
del /s /f *.vcxproj.user 2> nul
del /s /f *.vcxproj.filters 2> nul
del /s /f *.VC.db 2> nul

if /i "%~1" == "--all" (
	del /ah /s /f *.suo 2> nul
	del /s /f *.vcproj.*.user 2> nul
)

echo Removing VC++ profiling/instrumentation files...

del /s /f *.pbi 2> nul
del /s /f *.pbo 2> nul
del /s /f *.pbt 2> nul
del /s /f *._xe 2> nul
del /s /f *.pcc 2> nul
del /s /f *.stt 2> nul
del /s /f *.dpcov 2> nul

echo Removing WiX files...

del /s /f *.wixobj 2> nul
del /s /f *.wixpdb 2> nul
del /s /f *.msi 2> nul

echo Removing Chocolatey files...

for /d /r %%i in (Chocolatey) do if exist "%%i" (
	rmdir /s /q "%%i\bin" 2> nul
	del /f "%%i\*.nupkg" 2> nul
)

echo Removing Code::Blocks target files...

del /s /f *.gch 2> nul
del /s /f *.o 2> nul
del /s /f *.a 2> nul

echo Removing Code::Blocks workspace files...

if /i "%~1" == "--all" (
	del /s /f *.depend 2> nul
	del /s /f *.layout 2> nul
)

echo Removing Doxygen folders...

for /d /r %%i in (dox) do (
	if exist "%%i" (
		del "%%i\*.css" 2> nul
		del "%%i\*.html" 2> nul
		del "%%i\*.js" 2> nul
		del "%%i\*.png" 2> nul
		rmdir /q "%%i" 2> nul
	)
)

echo Removing log files...

del /s /f *.log 2> nul
del /s /f TraceLog.txt 2> nul
del /s /f *.sup 2> nul

echo Removing other files...

del /s /f *.mht 2> nul
for /d /r %%i in (debug)   do if exist "%%i" del /s /f "%%i\*.ini" 2> nul
for /d /r %%i in (release) do if exist "%%i" del /s /f "%%i\*.ini" 2> nul
rmdir /s /q VSMacros71 2> nul
for /d /r %%i in (*.tlog) do @if exist "%%i" rmdir "%%i" 2> nul
del /s /f unsuccessfulbuild 2> nul
del /s /f RSP*.rsp 2> nul
del /s /f *.zip 2> nul

echo Removing Debug and Release directories...

for /d %%i in (*) do (
	for /d %%j in ("%%i\ipch") do (
		for /d %%k in ("%%j\*") do rmdir "%%k" 2> nul
		rmdir "%%j" 2> nul
	)
)

for /d /r %%i in (debug)   do if exist "%%i" rmdir "%%i" 2> nul
for /d /r %%i in (release) do if exist "%%i" rmdir "%%i" 2> nul
for /d /r %%i in (x64)     do if exist "%%i" rmdir "%%i" 2> nul

:success
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [--all]
goto :eof
