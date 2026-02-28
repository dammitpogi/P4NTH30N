description: Creates a Storage QoS policy
synopses:
- New-StorageQosPolicy [[-PolicyId] <Guid>] [[-Name] <String>] [[-MaximumIops] <UInt64>]
  [[-MinimumIops] <UInt64>] [[-MaximumIOBandwidth] <UInt64>] [[-ParentPolicy] <CimInstance>]
  [[-PolicyType] <PolicyType>] [-AsJob] [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-StorageQosPolicy [-Policy] <CimInstance> [-AsJob] [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -Confirm,-cf Switch: ~
  -MaximumIOBandwidth UInt64: ~
  -MaximumIops UInt64: ~
  -MinimumIops UInt64: ~
  -Name String: ~
  -ParentPolicy CimInstance: ~
  -Policy CimInstance:
    required: true
  -PolicyId Guid: ~
  -PolicyType PolicyType:
    values:
    - Aggregated
    - Dedicated
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
