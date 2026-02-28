description: Adds an attribute store to the Federation Service
synopses:
- Add-AdfsAttributeStore -Name <String> -StoreType <String> -Configuration <Hashtable>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsAttributeStore -Name <String> -TypeQualifiedName <String> -Configuration
  <Hashtable> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Configuration Hashtable:
    required: true
  -Name String:
    required: true
  -PassThru Switch: ~
  -StoreType String:
    required: true
    values:
    - ActiveDirectory
    - LDAP
    - SQL
  -TypeQualifiedName String:
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
