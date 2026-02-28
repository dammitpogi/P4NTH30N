description: Renames a property of an item
synopses:
- Rename-ItemProperty [-Path] <String> [-Name] <String> [-NewName] <String> [-PassThru]
  [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-ItemProperty -LiteralPath <String> [-Name] <String> [-NewName] <String> [-PassThru]
  [-Force] [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Exclude System.String[]: ~
  -Filter System.String: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -Name,-PSProperty System.String:
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
