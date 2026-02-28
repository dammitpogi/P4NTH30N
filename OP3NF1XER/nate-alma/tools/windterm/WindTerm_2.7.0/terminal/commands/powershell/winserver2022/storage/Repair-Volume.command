description: Performs repairs on a volume
synopses:
- Repair-Volume [-DriveLetter] <Char[]> [-OfflineScanAndFix] [-SpotFix] [-Scan] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Repair-Volume -ObjectId <String[]> [-OfflineScanAndFix] [-SpotFix] [-Scan] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Repair-Volume -Path <String[]> [-OfflineScanAndFix] [-SpotFix] [-Scan] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Repair-Volume -FileSystemLabel <String[]> [-OfflineScanAndFix] [-SpotFix] [-Scan]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Repair-Volume -InputObject <CimInstance[]> [-OfflineScanAndFix] [-SpotFix] [-Scan]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DriveLetter Char[]:
    required: true
  -FileSystemLabel String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -ObjectId,-Id String[]:
    required: true
  -OfflineScanAndFix Switch: ~
  -Path String[]:
    required: true
  -Scan Switch: ~
  -SpotFix Switch: ~
  -ThrottleLimit Int32: ~
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
