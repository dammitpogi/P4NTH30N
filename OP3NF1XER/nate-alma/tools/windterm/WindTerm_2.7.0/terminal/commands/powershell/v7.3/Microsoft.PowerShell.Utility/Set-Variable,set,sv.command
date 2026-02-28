description: Sets the value of a variable. Creates the variable if one with the requested
  name does not exist
synopses:
- Set-Variable [-Name] <String[]> [[-Value] <Object>] [-Include <String[]>] [-Exclude
  <String[]>] [-Description <String>] [-Option <ScopedItemOptions>] [-Force] [-Visibility
  <SessionStateEntryVisibility>] [-PassThru] [-Scope <String>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Description System.String: ~
  -Exclude System.String[]: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -Name System.String[]:
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
