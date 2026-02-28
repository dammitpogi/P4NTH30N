description: Creates a new property for an item and sets its value
synopses:
- New-ItemProperty [-Path] <String[]> [-Name] <String> [-PropertyType <String>] [-Value
  <Object>] [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>]
  [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-ItemProperty -LiteralPath <String[]> [-Name] <String> [-PropertyType <String>]
  [-Value <Object>] [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>]
  [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Name,-PSProperty System.String:
    required: true
  -Path System.String[]:
    required: true
  -PropertyType,-Type System.String: ~
  -Value System.Object: ~
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
