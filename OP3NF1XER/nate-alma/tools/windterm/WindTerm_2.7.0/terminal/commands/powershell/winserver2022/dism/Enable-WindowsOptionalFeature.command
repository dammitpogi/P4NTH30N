description: Enables a feature in a Windows image
synopses:
- Enable-WindowsOptionalFeature -FeatureName <String[]> [-PackageName <String>] [-All]
  [-LimitAccess] [-Source <String[]>] [-NoRestart] [-Online] [-WindowsDirectory <String>]
  [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory <String>] [-LogLevel
  <LogLevel>] [<CommonParameters>]
- Enable-WindowsOptionalFeature -FeatureName <String[]> [-PackageName <String>] [-All]
  [-LimitAccess] [-Source <String[]>] [-NoRestart] -Path <String> [-WindowsDirectory
  <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory <String>]
  [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -All Switch: ~
  -FeatureName String[]:
    required: true
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
  -PackageName String: ~
  -Path String:
    required: true
  -ScratchDirectory String: ~
  -Source String[]: ~
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
