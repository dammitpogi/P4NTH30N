description: Creates a new alias
synopses:
- New-Alias [-Name] <String> [-Value] <String> [-Description <String>] [-Option <ScopedItemOptions>]
  [-PassThru] [-Scope <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Description System.String: ~
  -Force Switch: ~
  -Name System.String:
    required: true
  -Option System.Management.Automation.ScopedItemOptions:
    values:
    - None
    - ReadOnly
    - Constant
    - Private
    - AllScope
    - Unspecified
  -PassThru Switch: ~
  -Scope System.String: ~
  -Value System.String:
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
