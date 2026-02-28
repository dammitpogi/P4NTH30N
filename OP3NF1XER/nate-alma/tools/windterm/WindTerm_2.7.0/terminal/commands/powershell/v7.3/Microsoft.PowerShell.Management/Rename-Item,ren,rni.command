description: Renames an item in a PowerShell provider namespace
synopses:
- Rename-Item [-Path] <String> [-NewName] <String> [-Force] [-PassThru] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm]  [<CommonParameters>]
- Rename-Item -LiteralPath <String> [-NewName] <String> [-Force] [-PassThru] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm]  [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -NewName System.String:
    required: true
  -PassThru Switch: ~
  -Path System.String:
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
