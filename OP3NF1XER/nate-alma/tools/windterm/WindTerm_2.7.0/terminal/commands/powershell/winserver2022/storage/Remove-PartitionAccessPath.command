description: Removes an access path such as a drive letter or folder from a partition
synopses:
- Remove-PartitionAccessPath [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-PartitionAccessPath -DiskId <String[]> -Offset <UInt64[]> [[-AccessPath]
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-PartitionAccessPath [-DiskNumber] <UInt32[]> [-PartitionNumber] <UInt32[]>
  [[-AccessPath] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-PartitionAccessPath -DriveLetter <Char[]> [[-AccessPath] <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-PartitionAccessPath -InputObject <CimInstance[]> [[-AccessPath] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AccessPath String: ~
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
