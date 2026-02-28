description: Copies an item from one location to another
synopses:
- Copy-Item [-Path] <String[]> [[-Destination] <String>] [-Container] [-Force] [-Filter
  <String>] [-Include <String[]>] [-Exclude <String[]>] [-Recurse] [-PassThru] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [-FromSession <PSSession>] [-ToSession <PSSession>]
  [<CommonParameters>]
- Copy-Item -LiteralPath <String[]> [[-Destination] <String>] [-Container] [-Force]
  [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Recurse] [-PassThru]
  [-Credential <PSCredential>] [-WhatIf] [-Confirm] [-FromSession <PSSession>] [-ToSession
  <PSSession>] [<CommonParameters>]
options:
  -Container Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Destination System.String: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Force Switch: ~
  -FromSession System.Management.Automation.Runspaces.PSSession: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -PassThru Switch: ~
  -Path System.String[]:
    required: true
  -Recurse Switch: ~
  -ToSession System.Management.Automation.Runspaces.PSSession: ~
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
