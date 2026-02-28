description: Returns a list of the app packages that are installed and configured
  as non-removable apps
synopses:
- Get-NonRemovableAppsPolicy -Path <String> [-WindowsDirectory <String>] [-SystemDrive
  <String>] [-LogPath <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>]
  [<CommonParameters>]
- Get-NonRemovableAppsPolicy [-Online] [-WindowsDirectory <String>] [-SystemDrive
  <String>] [-LogPath <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>]
  [<CommonParameters>]
options:
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
    - Debug
  -LogPath,-LP String: ~
  -Online Switch:
    required: true
  -Path String:
    required: true
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
