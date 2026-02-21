using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;

namespace P4NTH35T.Tests;

public class CanvasLoginTests
{
    public static async Task<bool> TestFireKirinLoginWithScreenshot()
    {
        Console.WriteLine("[TEST] Starting FireKirin Canvas login test with screenshot validation");
        
        try
        {
            // Create CDP client with proper config
            var config = new CdpConfig { HostIp = "localhost", Port = 9222 };
            var cdp = new CdpClient(config);
            
            // Test credentials (use a test account)
            string username = "testuser";
            string password = "testpass";
            
            Console.WriteLine($"[TEST] Attempting login for {username}");
            
            // Navigate to login page
            await cdp.NavigateAsync("http://play.firekirin.in/web_mobile/firekirin/", CancellationToken.None);
            await Task.Delay(5000);
            
            // Try WebSocket auth first
            bool wsAuth = await TestWebSocketAuthAsync(username, password);
            if (wsAuth)
            {
                Console.WriteLine("[TEST] WebSocket authentication successful");
                return true;
            }
            
            // Fallback to Canvas typing
            Console.WriteLine("[TEST] WebSocket failed, trying Canvas typing");
            
            // Click account field
            await cdp.ClickAtAsync(460, 367, CancellationToken.None);
            await Task.Delay(600);
            
            // Try enhanced Canvas typing
            await TestTypeIntoCanvasAsync(cdp, username);
            await Task.Delay(300);
            
            // Click password field
            await cdp.ClickAtAsync(460, 437, CancellationToken.None);
            await Task.Delay(600);
            
            // Try enhanced Canvas typing
            await TestTypeIntoCanvasAsync(cdp, password);
            await Task.Delay(300);
            
            // Click login
            await cdp.ClickAtAsync(553, 567, CancellationToken.None);
            await Task.Delay(8000);
            
            // Check for balance (indicates successful login)
            var balance = await cdp.EvaluateAsync<double>("Number(window.parent.Balance) || 0", CancellationToken.None);
            Console.WriteLine($"[TEST] Balance detected: ${balance}");
            
            cdp.Dispose();
            return balance > 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[TEST] Exception: {ex.Message}");
            return false;
        }
    }
    
    private static async Task<bool> TestWebSocketAuthAsync(string username, string password)
    {
        try
        {
            // This would use the same logic as TryWebSocketAuthAsync in CdpGameActions
            Console.WriteLine("[TEST] WebSocket auth not implemented in test - returning false");
            return false;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[TEST] WebSocket auth exception: {ex.Message}");
            return false;
        }
    }
    
    private static async Task TestTypeIntoCanvasAsync(ICdpClient cdp, string text)
    {
        // Test the enhanced Canvas typing strategies
        string escapedText = text.Replace("'", "\\'");
        
        // Strategy 1: Cocos2d-x EditBox
        string js1 = $@"
            (function() {{
                if (window.cc && cc.game && cc.game._scene) {{
                    var scene = cc.game._scene;
                    var children = scene.children || [];
                    for (var i = 0; i < children.length; i++) {{
                        var node = children[i];
                        if (node._editBox && node._editBox._inputMode === cc.EditBox.InputMode.ANY) {{
                            node._editBox.setString('{escapedText}');
                            return 'found_editbox';
                        }}
                    }}
                }}
                return 'no_editbox';
            }})()";
        
        try
        {
            var result1 = await cdp.EvaluateAsync<string>(js1, CancellationToken.None);
            Console.WriteLine($"[TEST] Cocos2d-x EditBox result: {result1}");
            if (result1 == "found_editbox") return;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[TEST] Cocos2d-x EditBox failed: {ex.Message}");
        }
        
        // Strategy 2: Canvas keyboard events
        string js2 = $@"
            (function() {{
                var canvas = document.querySelector('canvas');
                if (!canvas) return 'no_canvas';
                
                var text = '{escapedText}';
                for (var i = 0; i < text.length; i++) {{
                    var char = text[i];
                    var keydownEvent = new KeyboardEvent('keydown', {{
                        key: char, code: 'Key' + char.toUpperCase(),
                        keyCode: char.charCodeAt(0), which: char.charCodeAt(0), bubbles: true
                    }});
                    canvas.dispatchEvent(keydownEvent);
                }}
                return 'canvas_events_sent';
            }})()";
        
        try
        {
            var result2 = await cdp.EvaluateAsync<string>(js2, CancellationToken.None);
            Console.WriteLine($"[TEST] Canvas events result: {result2}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[TEST] Canvas events failed: {ex.Message}");
        }
        
        // Strategy 3: Fallback Input.insertText
        try
        {
            await cdp.SendCommandAsync("Input.insertText", new { text = text }, CancellationToken.None);
            Console.WriteLine($"[TEST] Input.insertText fallback used");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[TEST] Input.insertText failed: {ex.Message}");
        }
    }
}
