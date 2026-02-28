@echo off
:: Check Docker is running
docker ps >nul 2>&1
if %errorlevel% equ 0 exit /b 0

echo.
echo ========================================
echo   Docker is not running
echo ========================================
echo.
echo Please start Rancher Desktop and wait
echo for it to fully initialize.
echo.
:retry_loop
choice /C YNQ /M "Try again (Y), Continue anyway (N), or Quit (Q)"
if errorlevel 3 exit /b 1
if errorlevel 2 exit /b 0

:: Try again
docker ps >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Docker is running
    exit /b 0
)

echo Docker still not responding...
goto :retry_loop
