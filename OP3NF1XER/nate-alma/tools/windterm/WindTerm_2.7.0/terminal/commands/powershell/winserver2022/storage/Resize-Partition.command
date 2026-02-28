description: Resizes a partition and the underlying file system
synopses:
- Resize-Partition [-WhatIf] [-Confirm] [<CommonParameters>]
- Resize-Partition -DiskId <String[]> -Offset <UInt64[]> [-Size] <UInt64> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Resize-Partition [-DiskNumber] <UInt32[]> [-PartitionNumber] <UInt32[]> [-Size]
  <UInt64> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Resize-Partition -DriveLetter <Char[]> [-Size] <UInt64> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Resize-Partition -InputObject <CimInstance[]> [-Size] <UInt64> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DiskId String[]:
    required: true
  -DiskNumber UInt32[]:
    required: true
  -DriveLetter Char[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Offset UInt64[]:
    required: true
  -PartitionNumber,-Number UInt32[]:
    required: true
  -PassThru Switch: ~
  -Size UInt64:
    required: true
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
