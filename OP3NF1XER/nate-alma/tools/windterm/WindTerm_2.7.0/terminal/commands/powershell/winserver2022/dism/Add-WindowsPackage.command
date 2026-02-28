description: Adds a single .cab or .msu file to a Windows image
synopses:
- Add-WindowsPackage -PackagePath <String> [-IgnoreCheck] [-PreventPending] [-NoRestart]
  [-Online] [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Add-WindowsPackage -PackagePath <String> [-IgnoreCheck] [-PreventPending] [-NoRestart]
  -Path <String> [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -IgnoreCheck Switch: ~
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -NoRestart Switch: ~
  -Online Switch:
    required: true
  -PackagePath String:
    required: true
  -Path String:
    required: true
  -PreventPending Switch: ~
  -ScratchDirectory String: ~
  -SystemDrive String: ~
  -WindowsDirectory String: ~
  -Debug,-db Switch: ~
  -ErrorAction,-ea ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -ErrorVariable,-ev String: ~
  -InformationAction,-ia ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -InformationVariable,-iv String: ~
  -OutVariable,-ov String: ~
  -OutBuffer,-ob Int32: ~
  -PipelineVariable,-pv String: ~
  -Verbose,-vb Switch: ~
  -WarningAction,-wa ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -WarningVariable,-wv String: ~
