description: Initializes a RAW disk for first time use, enabling the disk to be formatted
  and used to store data
synopses:
- Initialize-Disk [-Number] <UInt32[]> [-PartitionStyle <PartitionStyle>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Initialize-Disk -UniqueId <String[]> [-PartitionStyle <PartitionStyle>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Initialize-Disk [-FriendlyName <String[]>] [-PartitionStyle <PartitionStyle>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Initialize-Disk -Path <String[]> [-PartitionStyle <PartitionStyle>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Initialize-Disk [-VirtualDisk <CimInstance>] [-PartitionStyle <PartitionStyle>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Initialize-Disk -InputObject <CimInstance[]> [-PartitionStyle <PartitionStyle>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -FriendlyName String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Number UInt32[]:
    required: true
  -PartitionStyle PartitionStyle:
    values:
    - Unknown
    - MBR
    - GPT
  -PassThru Switch: ~
  -Path String[]:
    required: true
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]:
    required: true
  -VirtualDisk CimInstance: ~
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
