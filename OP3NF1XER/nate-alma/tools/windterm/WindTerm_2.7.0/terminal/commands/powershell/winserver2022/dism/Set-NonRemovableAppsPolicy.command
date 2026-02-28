description: Sets an app package as non-removable (can not be uninstalled)
synopses:
- Set-NonRemovableAppsPolicy -PackageFamilyName <String> -NonRemovable <Int32> -Path
  <String> [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Set-NonRemovableAppsPolicy -PackageFamilyName <String> -NonRemovable <Int32> [-Online]
  [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
    - Debug
  -LogPath,-LP String: ~
  -NonRemovable Int32:
    required: true
  -Online Switch:
    required: true
  -PackageFamilyName String:
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
