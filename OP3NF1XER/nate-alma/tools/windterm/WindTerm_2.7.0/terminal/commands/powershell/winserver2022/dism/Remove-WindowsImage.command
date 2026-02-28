description: Deletes the specified volume image from a WIM file that has multiple
  volume images
synopses:
- Remove-WindowsImage -ImagePath <String> -Name <String> [-CheckIntegrity] [-LogPath
  <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Remove-WindowsImage -ImagePath <String> -Index <UInt32> [-CheckIntegrity] [-LogPath
  <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -CheckIntegrity Switch: ~
  -ImagePath String:
    required: true
  -Index UInt32:
    required: true
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Name String:
    required: true
  -ScratchDirectory String: ~
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
