description: Applies an unattended answer file to a Windows image
synopses:
- Use-WindowsUnattend -UnattendPath <String> [-NoRestart] -Path <String> [-WindowsDirectory
  <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory <String>]
  [-LogLevel <LogLevel>] [<CommonParameters>]
- Use-WindowsUnattend -UnattendPath <String> [-NoRestart] [-Online] [-WindowsDirectory
  <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory <String>]
  [-LogLevel <LogLevel>] [<CommonParameters>]
options:
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
  -ScratchDirectory String: ~
  -SystemDrive String: ~
  -UnattendPath String:
    required: true
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
