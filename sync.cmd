@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync.ps1" %*
set EXITCODE=%ERRORLEVEL%
echo.
if %EXITCODE% neq 0 (
  echo [sync] 失败，退出码：%EXITCODE%
) else (
  echo [sync] 已完成。
)
endlocal & exit /b %EXITCODE%
