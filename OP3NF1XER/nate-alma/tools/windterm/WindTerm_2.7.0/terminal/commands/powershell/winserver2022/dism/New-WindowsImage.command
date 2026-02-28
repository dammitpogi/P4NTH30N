description: Captures an image of a drive to a new WIM file
synopses:
- New-WindowsImage -ImagePath <String> -CapturePath <String> [-CompressionType <String>]
  [-ConfigFilePath <String>] [-Description <String>] -Name <String> [-CheckIntegrity]
  [-NoRpFix] [-Setbootable] [-Verify] [-WIMBoot] [-SupportEa] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -CapturePath String:
    required: true
  -CheckIntegrity Switch: ~
  -CompressionType String: ~
  -ConfigFilePath String: ~
  -Description String: ~
  -ImagePath String:
    required: true
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Name String:
    required: true
  -NoRpFix Switch: ~
  -ScratchDirectory String: ~
  -Setbootable,-SB Switch: ~
  -SupportEa Switch: ~
  -Verify Switch: ~
  -WIMBoot Switch: ~
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
