description: Applies an image to a specified location
synopses:
- Expand-WindowsImage -ImagePath <String> -Name <String> [-SplitImageFilePattern <String>]
  -ApplyPath <String> [-CheckIntegrity] [-ConfirmTrustedFile] [-NoRpFix] [-Verify]
  [-WIMBoot] [-Compact] [-SupportEa] [-LogPath <String>] [-ScratchDirectory <String>]
  [-LogLevel <LogLevel>] [<CommonParameters>]
- Expand-WindowsImage -ImagePath <String> -Index <UInt32> [-SplitImageFilePattern
  <String>] -ApplyPath <String> [-CheckIntegrity] [-ConfirmTrustedFile] [-NoRpFix]
  [-Verify] [-WIMBoot] [-Compact] [-SupportEa] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -ApplyPath String:
    required: true
  -CheckIntegrity Switch: ~
  -Compact Switch: ~
  -ConfirmTrustedFile Switch: ~
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
  -NoRpFix Switch: ~
  -ScratchDirectory String: ~
  -SplitImageFilePattern String: ~
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
