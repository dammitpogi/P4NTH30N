description: Captures an image of customized or serviced Windows components on a Windows
  Image File Boot (WIMBoot) configured device
synopses:
- New-WindowsCustomImage -CapturePath <String> [-ConfigFilePath <String>] [-CheckIntegrity]
  [-Verify] [-LogPath <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>]
  [<CommonParameters>]
options:
  -CapturePath String:
    required: true
  -CheckIntegrity Switch: ~
  -ConfigFilePath String: ~
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -ScratchDirectory String: ~
  -Verify Switch: ~
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
