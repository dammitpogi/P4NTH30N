@echo off
echo Copying T00L5ET to correct location for OpenCode...

REM Copy from build output to expected location
xcopy "C:\Users\paulc\OneDrive\Desktop\build\T00L5ET\bin\Release\net10.0-windows7.0\*" "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\" /E /H /Y

REM Copy deploy manifest
copy "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\deploy-manifest.json" "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\deploy-manifest.json" /Y

echo T00L5ET copied to correct location!
echo.
echo Now you can run: T00L5ET.exe mcp-server --workspace "C:\P4NTH30N"
pause
