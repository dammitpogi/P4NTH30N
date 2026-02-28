description: Deletes temporary PowerShell drives and disconnects mapped network drives
synopses:
- Remove-PSDrive [-Name] <String[]> [-PSProvider <String[]>] [-Scope <String>] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-PSDrive [-LiteralName] <String[]> [-PSProvider <String[]>] [-Scope <String>]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Force Switch: ~
  -LiteralName System.String[]:
    required: true
  -Name System.String[]:
    required: true
  -PSProvider System.String[]: ~
  -Scope System.String: ~
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
