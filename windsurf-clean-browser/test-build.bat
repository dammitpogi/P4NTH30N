@echo off
:: Simple test script

echo Testing docker build...
docker build --no-cache -t test-windsurf-browser .

echo.
echo Errorlevel: %errorlevel%

if errorlevel 1 (
    echo Build failed!
) else (
    echo Build succeeded!
)

pause
