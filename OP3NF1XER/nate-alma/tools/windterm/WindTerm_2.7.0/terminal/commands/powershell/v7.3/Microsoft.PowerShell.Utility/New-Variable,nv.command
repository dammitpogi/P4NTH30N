description: Creates a new variable
synopses:
- New-Variable [-Name] <String> [[-Value] <Object>] [-Description <String>] [-Option
  <ScopedItemOptions>] [-Visibility <SessionStateEntryVisibility>] [-Force] [-PassThru]
  [-Scope <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -Value System.Object: ~
  -Visibility System.Management.Automation.SessionStateEntryVisibility:
    values:
    - Public
    - Private
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
