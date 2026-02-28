description: Exports a copy of the specified image to another image file
synopses:
- Export-WindowsImage [-CheckIntegrity] [-CompressionType <String>] -DestinationImagePath
  <String> [-DestinationName <String>] [-Setbootable] -SourceImagePath <String> -SourceName
  <String> [-SplitImageFilePattern <String>] [-WIMBoot] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Export-WindowsImage [-CheckIntegrity] [-CompressionType <String>] -DestinationImagePath
  <String> [-DestinationName <String>] [-Setbootable] -SourceImagePath <String> -SourceIndex
  <UInt32> [-SplitImageFilePattern <String>] [-WIMBoot] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -CheckIntegrity Switch: ~
  -CompressionType String: ~
  -DestinationImagePath,-DIP String:
    required: true
  -DestinationName,-DN String: ~
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -ScratchDirectory String: ~
  -Setbootable,-SB Switch: ~
  -SourceImagePath,-SIP String:
    required: true
  -SourceIndex,-SI UInt32:
    required: true
  -SourceName,-SN String:
    required: true
  -SplitImageFilePattern String: ~
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
