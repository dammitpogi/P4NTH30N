description: Changes the value of an IIS configuration element
synopses:
- Set-WebConfiguration -Value <PSObject> [-Metadata <String>] [-Clr <String>] [-Force]
  [-Location <String[]>] [-Filter] <String[]> [[-PSPath] <String[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-WebConfiguration -InputObject <Object> [-Metadata <String>] [-Clr <String>]
  [-Force] [-Location <String[]>] [-Filter] <String[]> [[-PSPath] <String[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Clr String: ~
  -Confirm,-cf Switch: ~
  -Filter String[]:
    required: true
  -Force Switch: ~
  -InputObject Object:
    required: true
  -Location String[]: ~
  -Metadata String: ~
  -PSPath String[]: ~
  -Value,-v,-val PSObject:
    required: true
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
