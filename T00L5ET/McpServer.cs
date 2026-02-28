using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace P4NTHE0N.T00L5ET.McpServer
{
    public class McpServer
    {
        private readonly ILogger<McpServer> _logger;
        private readonly P4NTHE0N.T00L5ET.Core.P4NTHE0NTools _tools;

        public McpServer(ILogger<McpServer> logger)
        {
            _logger = logger;
            _tools = new P4NTHE0N.T00L5ET.Core.P4NTHE0NTools();
        }

        public async Task RunAsync()
        {
            _logger.LogInformation("P4NTHE0N Tools MCP Server starting...");
            
            // Simple MCP server loop - read from stdin, write to stdout
            var reader = Console.In;
            var writer = Console.Out;
            
            while (true)
            {
                var line = await reader.ReadLineAsync();
                if (string.IsNullOrEmpty(line)) continue;
                
                try
                {
                    var request = JsonDocument.Parse(line);
                    var response = await ProcessRequestAsync(request);
                    
                    await writer.WriteLineAsync(JsonSerializer.Serialize(response));
                    await writer.FlushAsync();
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error processing request: {ex.Message}");
                    
                    var errorResponse = new
                    {
                        jsonrpc = "2.0",
                        id = request.RootElement.TryGetProperty("id", out var idProp) ? idProp : null,
                        error = new
                        {
                            code = -32603,
                            message = $"Internal error: {ex.Message}"
                        }
                    };
                    
                    await writer.WriteLineAsync(JsonSerializer.Serialize(errorResponse));
                    await writer.FlushAsync();
                }
            }
        }

        private async Task<object> ProcessRequestAsync(JsonDocument request)
        {
            var method = request.RootElement.TryGetProperty("method", out var methodProp) 
                ? methodProp.GetString() 
                : null;

            if (string.IsNullOrEmpty(method))
            {
                return new { jsonrpc = "2.0", id = null, error = new { code = -32600, message = "Method not found" } };
            }

            try
            {
                return method switch
                {
                    "initialize" => await HandleInitializeAsync(request),
                    "tools/list" => await HandleToolsListAsync(),
                    "tools/call" => await HandleToolCallAsync(request),
                    _ => new { jsonrpc = "2.0", id = GetRequestId(request), error = new { code = -32601, message = $"Method not found: {method}" } }
                };
            }
            catch (Exception ex)
            {
                return new { jsonrpc = "2.0", id = GetRequestId(request), error = new { code = -32603, message = ex.Message } };
            }
        }

        private async Task<object> HandleInitializeAsync(JsonDocument request)
        {
            _logger.LogInformation("MCP initialize request received");
            
            return new
            {
                jsonrpc = "2.0",
                id = GetRequestId(request),
                result = new
                {
                    protocolVersion = "2024-11-05",
                    capabilities = new
                    {
                        tools = new { }
                    },
                    serverInfo = new
                    {
                        name = "P4NTHE0N Tools MCP",
                        version = "1.0.0"
                    }
                }
            };
        }

        private async Task<object> HandleToolsListAsync()
        {
            _logger.LogInformation("Tools list request received");
            
            var tools = new[]
            {
                new
                {
                    name = "list_credentials",
                    description = "List all stored credentials from MongoDB",
                    inputSchema = new { type = "object", properties = new { } }
                },
                new
                {
                    name = "get_credential",
                    description = "Get a specific credential by ID",
                    inputSchema = new
                    {
                        type = "object",
                        properties = new
                        {
                            id = new { type = "string", description = "Credential ID" }
                        }
                    },
                    required = new[] { "id" }
                },
                new
                {
                    name = "store_credential",
                    description = "Store a new credential",
                    inputSchema = new
                    {
                        type = "object",
                        properties = new
                        {
                            platform = new { type = "string", description = "Platform name" },
                            username = new { type = "string", description = "Username" },
                            password = new { type = "string", description = "Password" }
                        },
                        required = new[] { "platform", "username", "password" }
                    }
                },
                new
                {
                    name = "list_jackpots",
                    description = "List jackpot data from MongoDB",
                    inputSchema = new { type = "object", properties = new { } }
                },
                new
                {
                    name = "get_decision",
                    description = "Get a specific decision by ID",
                    inputSchema = new
                    {
                        type = "object",
                        properties = new
                        {
                            id = new { type = "string", description = "Decision ID" }
                        },
                        required = new[] { "id" }
                    }
                }
            };

            return new
            {
                jsonrpc = "2.0",
                id = null,
                result = new { tools = tools }
            };
        }

        private async Task<object> HandleToolCallAsync(JsonDocument request)
        {
            var paramsElement = request.RootElement.TryGetProperty("params", out var paramsProp) ? paramsProp : null;
            if (paramsElement == null)
            {
                return new { jsonrpc = "2.0", id = GetRequestId(request), error = new { code = -32602, message = "Missing params" } };
            }

            var nameElement = paramsElement.TryGetProperty("name", out var nameProp) ? nameProp : null;
            var argumentsElement = paramsElement.TryGetProperty("arguments", out var argsProp) ? argsProp : null;

            if (nameElement == null || string.IsNullOrEmpty(nameElement.GetString()))
            {
                return new { jsonrpc = "2.0", id = GetRequestId(request), error = new { code = -32602, message = "Missing tool name" } };
            }

            var toolName = nameElement.GetString();
            _logger.LogInformation($"Tool call: {toolName}");

            try
            {
                var result = await ExecuteToolAsync(toolName, argumentsElement);
                return new
                {
                    jsonrpc = "2.0",
                    id = GetRequestId(request),
                    result = result
                };
            }
            catch (Exception ex)
            {
                _logger.LogError($"Tool {toolName} failed: {ex.Message}");
                return new
                {
                    jsonrpc = "2.0",
                    id = GetRequestId(request),
                    error = new { code = -32603, message = $"Tool execution failed: {ex.Message}" }
                };
            }
        }

        private async Task<object> ExecuteToolAsync(string toolName, JsonElement? arguments)
        {
            var args = arguments?.ValueKind == JsonValueKind.Object 
                ? arguments.EnumerateObject().ToDictionary(kvp => kvp.Key, kvp => kvp.Value)
                : new Dictionary<string, object>();

            return toolName switch
            {
                "list_credentials" => await _tools.ListCredentialsAsync(args),
                "get_credential" => await _tools.GetCredentialAsync(args),
                "store_credential" => await _tools.StoreCredentialAsync(args),
                "list_jackpots" => await _tools.ListJackpotsAsync(args),
                "get_decision" => await _tools.GetDecisionAsync(args),
                _ => throw new ArgumentException($"Unknown tool: {toolName}")
            };
        }

        private static object? GetRequestId(JsonDocument request)
        {
            return request.RootElement.TryGetProperty("id", out var idProp) ? idProp : null;
        }
    }
}
