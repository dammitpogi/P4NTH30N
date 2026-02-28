description: Hides the virtual disk from the host when the Storage Management Provider
  in use does not support masking sets
synopses:
- Hide-VirtualDisk [-FriendlyName] <String[]> [-TargetPortAddresses <String[]>] [-InitiatorAddress
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Hide-VirtualDisk -UniqueId <String[]> [-TargetPortAddresses <String[]>] [-InitiatorAddress
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Hide-VirtualDisk -Name <String[]> [-TargetPortAddresses <String[]>] [-InitiatorAddress
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Hide-VirtualDisk -InputObject <CimInstance[]> [-TargetPortAddresses <String[]>]
  [-InitiatorAddress <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -FriendlyName String[]:
    required: true
  -InitiatorAddress String: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -TargetPortAddresses String[]: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]:
    required: true
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
