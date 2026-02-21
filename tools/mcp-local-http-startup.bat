@echo off
REM Start P4NTH30N Local MCP Servers in HTTP mode for ToolHive management
REM These servers will be registered as "remote" MCP servers in ToolHive

echo Starting P4NTH30N Local MCP Servers (HTTP mode)...
echo.

REM Start foureyes-mcp on port 5302
echo Starting foureyes-mcp on port 5302...
start "FourEyes MCP" /min cmd /c "cd /d C:\P4NTH30N\tools\mcp-foureyes && set MCP_PORT=5302 && node server.js --http"
timeout /t 2 /nobreak >nul

REM Start honeybelt-server on port 5303
echo Starting honeybelt-server on port 5303...
start "Honeybelt MCP" /min cmd /c "cd /d C:\P4NTH30N\tools\mcp-development\servers\honeybelt-server && set MCP_PORT=5303 && node dist\index.js --http"
timeout /t 2 /nobreak >nul

REM Start json-query-mcp on port 5304
echo Starting json-query-mcp on port 5304...
start "JSON Query MCP" /min cmd /c "cd /d C:\Users\paulc\AppData\Local\json-query-mcp && set MCP_PORT=5304 && node dist\index.js --http"
timeout /t 2 /nobreak >nul

echo.
echo All local MCP servers started in HTTP mode.
echo.
echo Waiting for servers to initialize...
timeout /t 3 /nobreak >nul

REM Register with ToolHive
echo.
echo Registering with ToolHive...
echo.

C:\Users\paulc\AppData\Local\ToolHive\bin\thv.exe run http://127.0.0.1:5302/mcp --name foureyes-mcp --group default
C:\Users\paulc\AppData\Local\ToolHive\bin\thv.exe run http://127.0.0.1:5303/mcp --name honeybelt-server-local --group default
C:\Users\paulc\AppData\Local\ToolHive\bin\thv.exe run http://127.0.0.1:5304/mcp --name json-query-mcp-local --group default

echo.
echo Done! Local MCPs are now managed by ToolHive.
echo Run 'thv list' to verify.
pause
