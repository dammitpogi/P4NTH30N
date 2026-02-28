description: Publishes a script
synopses:
- Publish-Script -Path <String> [-NuGetApiKey <String>] [-Repository <String>] [-Credential
  <PSCredential>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Publish-Script -LiteralPath <String> [-NuGetApiKey <String>] [-Repository <String>]
  [-Credential <PSCredential>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -LiteralPath,-PSPath System.String:
    required: true
  -NuGetApiKey System.String: ~
  -Path System.String:
    required: true
  -Repository System.String: ~
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
