description: Disables features of a network switch
synopses:
- Disable-NetworkSwitchFeature -CimSession <CimSession> -FeatureName <Int32> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-NetworkSwitchFeature -CimSession <CimSession> -Name <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-NetworkSwitchFeature -CimSession <CimSession> -InstanceId <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-NetworkSwitchFeature -CimSession <CimSession> -InputObject <CimInstance[]>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession:
    required: true
  -Confirm,-cf Switch: ~
  -FeatureName Int32:
    required: true
  -InputObject CimInstance[]:
    required: true
  -InstanceId String:
    required: true
  -Name String:
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
