description: Moves a property from one location to another
synopses:
- Move-ItemProperty [-Path] <String[]> [-Name] <String[]> [-Destination] <String>
  [-PassThru] [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>]
  [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Move-ItemProperty -LiteralPath <String[]> [-Name] <String[]> [-Destination] <String>
  [-PassThru] [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>]
  [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Destination System.String:
    required: true
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Name,-PSProperty System.String[]:
    required: true
  -PassThru Switch: ~
  -Path System.String[]:
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
