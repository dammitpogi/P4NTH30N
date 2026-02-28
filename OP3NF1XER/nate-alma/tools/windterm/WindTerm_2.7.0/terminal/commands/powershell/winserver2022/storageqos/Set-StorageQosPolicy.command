description: Modifies an existing Storage QoS policy
synopses:
- Set-StorageQosPolicy -Name <String[]> [[-NewName] <String>] [[-MaximumIops] <UInt64>]
  [[-MinimumIops] <UInt64>] [[-MaximumIOBandwidth] <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-StorageQosPolicy -PolicyId <Guid[]> [[-NewName] <String>] [[-MaximumIops] <UInt64>]
  [[-MinimumIops] <UInt64>] [[-MaximumIOBandwidth] <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-StorageQosPolicy -InputObject <CimInstance[]> [[-NewName] <String>] [[-MaximumIops]
  <UInt64>] [[-MinimumIops] <UInt64>] [[-MaximumIOBandwidth] <UInt64>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -MaximumIOBandwidth UInt64: ~
  -MaximumIops UInt64: ~
  -MinimumIops UInt64: ~
  -Name String[]:
    required: true
  -NewName String: ~
  -PassThru Switch: ~
  -PolicyId Guid[]:
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
