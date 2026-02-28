description: Optimizes a volume
synopses:
- Optimize-Volume [-DriveLetter] <Char[]> [-ReTrim] [-Analyze] [-Defrag] [-SlabConsolidate]
  [-TierOptimize] [-NormalPriority] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Optimize-Volume -ObjectId <String[]> [-ReTrim] [-Analyze] [-Defrag] [-SlabConsolidate]
  [-TierOptimize] [-NormalPriority] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Optimize-Volume -Path <String[]> [-ReTrim] [-Analyze] [-Defrag] [-SlabConsolidate]
  [-TierOptimize] [-NormalPriority] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Optimize-Volume -FileSystemLabel <String[]> [-ReTrim] [-Analyze] [-Defrag] [-SlabConsolidate]
  [-TierOptimize] [-NormalPriority] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Optimize-Volume -InputObject <CimInstance[]> [-ReTrim] [-Analyze] [-Defrag] [-SlabConsolidate]
  [-TierOptimize] [-NormalPriority] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Analyze Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Defrag Switch: ~
  -DriveLetter Char[]:
    required: true
  -FileSystemLabel String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -NormalPriority Switch: ~
  -ObjectId,-Id String[]:
    required: true
  -Path String[]:
    required: true
  -ReTrim Switch: ~
  -SlabConsolidate Switch: ~
  -ThrottleLimit Int32: ~
  -TierOptimize Switch: ~
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
