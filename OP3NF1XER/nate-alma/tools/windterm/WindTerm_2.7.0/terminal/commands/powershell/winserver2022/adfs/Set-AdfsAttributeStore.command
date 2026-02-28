description: Modifies properties of an attribute store
synopses:
- Set-AdfsAttributeStore [-Name <String>] [-Configuration <Hashtable>] [-TargetName]
  <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsAttributeStore [-Name <String>] [-Configuration <Hashtable>] [-TargetAttributeStore]
  <AttributeStore> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Configuration Hashtable: ~
  -Name String: ~
  -PassThru Switch: ~
  -TargetAttributeStore AttributeStore:
    required: true
  -TargetName String:
    required: true
  -Confirm,-cf Switch: ~
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
