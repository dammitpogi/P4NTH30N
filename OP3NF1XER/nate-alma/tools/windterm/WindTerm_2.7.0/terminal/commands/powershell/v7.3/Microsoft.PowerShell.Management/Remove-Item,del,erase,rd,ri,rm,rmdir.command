description: Deletes the specified items
synopses:
- Remove-Item [-Path] <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [-Recurse] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
  [-Stream <String[]>] [<CommonParameters>]
- Remove-Item -LiteralPath <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [-Recurse] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
  [-Stream <String[]>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Path System.String[]:
    required: true
  -Recurse Switch: ~
  -Stream System.String[]: ~
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
