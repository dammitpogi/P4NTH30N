description: Repairs a Windows image in a WIM or VHD file
synopses:
- Repair-WindowsImage [-CheckHealth] [-ScanHealth] [-RestoreHealth] [-StartComponentCleanup]
  [-LimitAccess] [-ResetBase] [-Defer] [-Source <String[]>] [-NoRestart] -Path <String>
  [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Repair-WindowsImage [-CheckHealth] [-ScanHealth] [-RestoreHealth] [-StartComponentCleanup]
  [-LimitAccess] [-ResetBase] [-Defer] [-Source <String[]>] [-NoRestart] [-Online]
  [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -CheckHealth Switch: ~
  -Defer Switch: ~
  -LimitAccess Switch: ~
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -NoRestart Switch: ~
  -Online Switch:
    required: true
  -Path String:
    required: true
  -ResetBase Switch: ~
  -RestoreHealth Switch: ~
  -ScanHealth Switch: ~
  -ScratchDirectory String: ~
  -Source String[]: ~
  -StartComponentCleanup Switch: ~
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
