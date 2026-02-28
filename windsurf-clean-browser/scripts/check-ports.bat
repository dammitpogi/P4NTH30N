@echo off
setlocal EnableDelayedExpansion

:: Check port 5900
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5900" ^| findstr "LISTENING"') do (
    echo.
    echo ========================================
    echo   Port 5900 in use - attempting fix
    echo ========================================
    taskkill /F /PID %%a >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Freed port 5900
        timeout /t 1 >nul
    ) else (
        echo [FAIL] Could not free port 5900
        echo Please close the application manually.
        pause
        exit /b 1
    )
)

:: Check port 6080
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":6080" ^| findstr "LISTENING"') do (
    echo.
    echo ========================================
    echo   Port 6080 in use - attempting fix
    echo ========================================
    taskkill /F /PID %%a >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Freed port 6080
        timeout /t 1 >nul
    ) else (
        echo [FAIL] Could not free port 6080
        echo Please close the application manually.
        pause
        exit /b 1
    )
)

exit /b 0
