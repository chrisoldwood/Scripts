@echo off
rem ************************************************************
rem
rem Sync all Git repos (bare and normal) by pushing or pulling.
rem
rem ************************************************************
setlocal enabledelayedexpansion

:handle_help_request
if /i "%~1" == "-?"     call :usage & exit /b 0
if /i "%~1" == "--help" call :usage & exit /b 0

:check_args
if /i "%~1" == "" call :usage & exit /b 1
if /i "%~1" == "pull" goto :pull
if /i "%~1" == "push" goto :push
call :usage & exit /b 1

:pull
for /d %%d in (*) do (
	if exist "%%d\.git" (
		call :pull_repo "%%d"
		if !errorlevel! neq 0 exit /b !errorlevel!
	) else (
		if exist "%%d\HEAD" (
			call :pull_repo "%%d"
			if !errorlevel! neq 0 exit /b !errorlevel!
		)
	)
)
exit /b 0

:push
set remote=origin
if /i not "%~2" == "" set remote=%~2

for /d %%d in (*) do (
	if exist "%%d\.git" (
		call :push_repo "%%d" "%remote%"
		if !errorlevel! neq 0 exit /b !errorlevel!
	) else (
		if exist "%%d\HEAD" (
			call :push_repo "%%d" "%remote%"
			if !errorlevel! neq 0 exit /b !errorlevel!
		)
	)
)
exit /b 0

rem ************************************************************
rem Functions
rem ************************************************************

:usage
echo.
echo Usage: %~n0 [pull ^| push [^<remote^>]]
echo.
echo e.g.   %~n0 pull 
echo        %~n0 push (defaults to origin)
echo        %~n0 push github 
goto :eof

:pull_repo
set repo=%~1
echo '%repo%'
pushd "%repo%"
git pull --rebase
if !errorlevel! neq 0 (
	echo ERROR: Failed to pull from repo
	exit /b !errorlevel!
)
popd
echo.
goto :eof

:push_repo
set repo=%~1
set remote=%~2
echo '%repo%'
pushd "%repo%"
git push %remote% master --tags
if !errorlevel! neq 0 (
	echo ERROR: Failed to push repo to remote '%remote%'
	exit /b !errorlevel!
)
popd
echo.
goto :eof
