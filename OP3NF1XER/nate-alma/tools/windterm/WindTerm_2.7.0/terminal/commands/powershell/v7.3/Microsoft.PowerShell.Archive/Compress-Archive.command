description: Creates a compressed archive, or zipped file, from specified files and
  directories
synopses:
- Compress-Archive [-Path] <String[]> [-DestinationPath] <String> [-CompressionLevel
  <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compress-Archive [-Path] <String[]> [-DestinationPath] <String> [-CompressionLevel
  <String>] -Update [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compress-Archive [-Path] <String[]> [-DestinationPath] <String> [-CompressionLevel
  <String>] -Force [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compress-Archive -LiteralPath <String[]> [-DestinationPath] <String> [-CompressionLevel
  <String>] -Update [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compress-Archive -LiteralPath <String[]> [-DestinationPath] <String> [-CompressionLevel
  <String>] -Force [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Compress-Archive -LiteralPath <String[]> [-DestinationPath] <String> [-CompressionLevel
  <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CompressionLevel System.String:
    values:
    - Optimal
    - NoCompression
    - Fastest
  -DestinationPath System.String:
    required: true
  -Force Switch:
    required: true
  -LiteralPath,-PSPath System.String[]:
    required: true
  -PassThru Switch: ~
  -Path System.String[]:
    required: true
  -Update Switch:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
