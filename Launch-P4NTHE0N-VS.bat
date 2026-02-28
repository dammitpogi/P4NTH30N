@echo off
REM P4NTHE0N Visual Studio Startup Script
REM Starts all MCP services before launching Visual Studio

echo === P4NTHE0N Visual Studio Startup ===

REM Start all MCP services
echo Starting P4NTHE0N MCP services...
powershell -ExecutionPolicy Bypass -File "C:\P4NTH30N\Start-All-MCP-Servers.ps1"

REM Launch Visual Studio with P4NTHE0N solution
echo.
echo Launching Visual Studio with P4NTHE0N solution...
"C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\devenv.exe" "C:\P4NTH30N\P4NTHE0N.slnx"

pause
