description: Deletes the contents of an item, but does not delete the item
synopses:
- Clear-Content [-Path] <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [-Stream
  <String>] [<CommonParameters>]
- Clear-Content -LiteralPath <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude
  <String[]>] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [-Stream
  <String>] [<CommonParameters>]
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
  -Stream System.String: ~
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
