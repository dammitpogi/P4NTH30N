description: Sets attributes of a partition, such as active, read-only, and offline
  states
synopses:
- Set-Partition [-IsReadOnly <Boolean>] [-NoDefaultDriveLetter <Boolean>] [-IsActive
  <Boolean>] [-IsHidden <Boolean>] [-IsShadowCopy <Boolean>] [-IsDAX <Boolean>] [-MbrType
  <UInt16>] [-GptType <String>] [-DiskNumber] <UInt32> [-PartitionNumber] <UInt32>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-Partition -InputObject <CimInstance[]> [-NewDriveLetter <Char>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition -InputObject <CimInstance[]> [-IsOffline <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition -InputObject <CimInstance[]> [-IsReadOnly <Boolean>] [-NoDefaultDriveLetter
  <Boolean>] [-IsActive <Boolean>] [-IsHidden <Boolean>] [-IsShadowCopy <Boolean>]
  [-IsDAX <Boolean>] [-MbrType <UInt16>] [-GptType <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition [-IsReadOnly <Boolean>] [-NoDefaultDriveLetter <Boolean>] [-IsActive
  <Boolean>] [-IsHidden <Boolean>] [-IsShadowCopy <Boolean>] [-IsDAX <Boolean>] [-MbrType
  <UInt16>] [-GptType <String>] -DriveLetter <Char> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition [-IsReadOnly <Boolean>] [-NoDefaultDriveLetter <Boolean>] [-IsActive
  <Boolean>] [-IsHidden <Boolean>] [-IsShadowCopy <Boolean>] [-IsDAX <Boolean>] [-MbrType
  <UInt16>] [-GptType <String>] -DiskId <String> -Offset <UInt64> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition -DiskId <String> -Offset <UInt64> [-NewDriveLetter <Char>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition -DiskId <String> -Offset <UInt64> [-IsOffline <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition -DriveLetter <Char> [-NewDriveLetter <Char>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition -DriveLetter <Char> [-IsOffline <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Partition [-DiskNumber] <UInt32> [-PartitionNumber] <UInt32> [-NewDriveLetter
  <Char>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-Partition [-DiskNumber] <UInt32> [-PartitionNumber] <UInt32> [-IsOffline <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DiskId String:
    required: true
  -DiskNumber UInt32:
    required: true
  -DriveLetter Char:
    required: true
  -GptType String: ~
  -InputObject CimInstance[]:
    required: true
  -IsActive Boolean: ~
  -IsDAX Boolean: ~
  -IsHidden Boolean: ~
  -IsOffline Boolean: ~
  -IsReadOnly Boolean: ~
  -IsShadowCopy Boolean: ~
  -MbrType UInt16: ~
  -NewDriveLetter Char: ~
  -NoDefaultDriveLetter Boolean: ~
  -Offset UInt64:
    required: true
  -PartitionNumber,-Number UInt32:
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
