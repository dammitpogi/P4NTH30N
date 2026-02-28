description: Creates a new item
synopses:
- New-Item [-Path] <String[]> [-ItemType <String>] [-Value <Object>] [-Force] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-Item [[-Path] <String[]>] -Name <String> [-ItemType <String>] [-Value <Object>]
  [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -ItemType,-Type System.String: ~
  -Name System.String:
    required: true
  -Path System.String[]: ~
  -Value,-Target System.Object: ~
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
