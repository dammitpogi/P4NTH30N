@echo off
:: Rebuild the container image

echo [DEBUG] Starting rebuild script...
echo [DEBUG] Current directory: %CD%

echo [DEBUG] Converting line endings in Dockerfile to Unix format...
powershell -Command "(Get-Content Dockerfile -Raw) -replace \"`r`n\", \"`n\" | Set-Content -NoNewline Dockerfile"
echo [DEBUG] Dockerfile line endings converted

echo [DEBUG] Stopping all running windsurf containers...
docker ps -a | findstr windsurf-browser
for /f "tokens=1" %%a in ('docker ps -a -q -f "name=windsurf"') do (
    echo [DEBUG] Stopping container: %%a
    docker stop %%a 2>nul
    docker rm -f %%a 2>nul
)
echo [DEBUG] All containers stopped

echo [DEBUG] Removing ALL windsurf images (including intermediate layers)...
for /f "tokens=3" %%a in ('docker images windsurf-clean-browser 2^>nul') do (
    echo [DEBUG] Removing image: %%a
    docker rmi -f %%a 2>nul
)
echo [DEBUG] Removed all windsurf images

echo [DEBUG] Full system prune...
docker system prune -a -f 2>nul
docker builder prune -a -f 2>nul
echo [DEBUG] System pruned

echo.
echo Building new container...
echo This will take 3-5 minutes...
echo.

echo [DEBUG] Disabling BuildKit and using classic builder for true no-cache...
set DOCKER_BUILDKIT=0

echo [DEBUG] Full Docker system cleanup before build...
docker system prune -a -f 2>nul
docker builder prune -a -f 2>nul
echo [DEBUG] System cleanup complete

docker build --no-cache --pull -t windsurf-clean-browser .
echo [DEBUG] After docker build, errorlevel: %errorlevel%

if errorlevel 1 (
    echo.
    echo ERROR: Build failed! Errorlevel was: %errorlevel%
    pause
    exit /b 1
)

:: Remove rebuild flag if exists
if exist ".rebuild-required" del ".rebuild-required"

echo.
echo [OK] Build complete! Exiting with errorlevel: %errorlevel%
