$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\paulc\OneDrive\Desktop\Windsurf Browser.lnk")
$Shortcut.TargetPath = "C:\P4NTH30N\windsurf-clean-browser\launch.bat"
$Shortcut.WorkingDirectory = "C:\P4NTH30N\windsurf-clean-browser"
$Shortcut.IconLocation = "C:\Windows\System32\shell32.dll,14"
$Shortcut.Description = "Launch Windsurf Clean Browser"
$Shortcut.Save()
