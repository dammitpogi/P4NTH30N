@echo off
setlocal EnableDelayedExpansion

:: ============================================
:: Windsurf Clean Browser Launcher
:: Auto-healing, auto-disassembly, single shortcut
:: ============================================

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%~f0'"
    exit /b
)

cd /d "C:\P4NTH30N\windsurf-clean-browser"

:: Check if rebuild is needed (Dockerfile or scripts changed)
if exist ".rebuild-required" (
    echo.
    echo ========================================
    echo   Rebuild required
    echo ========================================
    echo.
    call scripts\rebuild.bat
    if errorlevel 1 exit /b 1
    :: Return to correct directory after rebuild
    cd /d "C:\P4NTH30N\windsurf-clean-browser"
)

:: Check Docker
call scripts\check-docker.bat
if errorlevel 1 exit /b 1

:: Stop any existing container to ensure fresh start
for /f "tokens=*" %%a in ('docker ps -q -f "name=windsurf-browser"') do (
    echo.
    echo ========================================
    echo   Stopping existing container
    echo ========================================
    docker stop windsurf-browser >nul 2>&1
    timeout /t 2 >nul
)

:: Check if image exists (but skip if we already handled rebuild above)
if not exist ".rebuild-required" (
    for /f "tokens=*" %%a in ('docker images -q windsurf-clean-browser:latest') do (
        goto :image_exists
    )
    
    :: No image - need to build
    echo.
    echo ========================================
    echo   Building container (one-time only)
    echo ========================================
    echo.
    call scripts\rebuild.bat
    if errorlevel 1 exit /b 1
)

:image_exists
:: Check ports
call scripts\check-ports.bat
if errorlevel 1 exit /b 1

:: Launch
echo.
echo ========================================
echo   Starting Windsurf Clean Browser
echo ========================================
echo.
echo Access URLs:
echo   Web: http://localhost:6080/vnc.html
echo   VNC: localhost:5900
echo.
echo VNC Password: windsurf
echo.

start http://localhost:6080/vnc.html
docker run --rm -p 5900:5900 -p 6080:6080 --name windsurf-browser windsurf-clean-browser

REM Container exited - check if it was killed or stopped normally
if errorlevel 1 (
    echo [DEBUG] Container exited with error, cleaning up...
    docker stop windsurf-browser 2>nul
    docker rm windsurf-browser 2>nul
)

:: Container stopped - auto-disassembled by --rm
echo.
echo ========================================
echo   Container stopped and removed
echo ========================================
echo.

:: Container stopped - auto-disassembled by --rm
echo.
echo ========================================
echo   Container stopped and removed
echo ========================================
echo.
echo Press any key to exit...
pause >nul
