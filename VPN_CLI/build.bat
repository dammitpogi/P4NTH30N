@echo off
echo ==========================================
echo Building VPN CLI Tool
echo ==========================================
echo.

set BUILD_CONFIG=Release
set TARGET_RUNTIME=win-x64
set OUTPUT_DIR=.\bin\%BUILD_CONFIG%\net8.0-windows7.0\%TARGET_RUNTIME%\publish

echo Cleaning previous builds...
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"

echo.
echo Restoring NuGet packages...
dotnet restore

echo.
echo Building project...
dotnet build -c %BUILD_CONFIG%

if %ERRORLEVEL% neq 0 (
    echo Build failed!
    exit /b 1
)

echo.
echo Publishing single-file executable...
dotnet publish -c %BUILD_CONFIG% -r %TARGET_RUNTIME% --self-contained true ^
    -p:PublishSingleFile=true ^
    -p:PublishReadyToRun=true ^
    -p:IncludeNativeLibrariesForSelfExtract=true

if %ERRORLEVEL% neq 0 (
    echo Publish failed!
    exit /b 1
)

echo.
echo ==========================================
echo Build completed successfully!
echo ==========================================
echo.
echo Output: %OUTPUT_DIR%\vpn.exe
echo.

if exist "%OUTPUT_DIR%\vpn.exe" (
    echo File size:
    dir "%OUTPUT_DIR%\vpn.exe" | find "vpn.exe"
    echo.
    
    echo Testing executable...
    "%OUTPUT_DIR%\vpn.exe" info version
    echo.
    
    echo Build completed! You can now use:
    echo   %OUTPUT_DIR%\vpn.exe
    echo.
    echo Or copy to a directory in your PATH:
    echo   copy "%OUTPUT_DIR%\vpn.exe" C:\Tools\
) else (
    echo ERROR: vpn.exe was not created!
    exit /b 1
)

pause