description: Registers an SMI-S provider and stores the configuration in the SMI-S
  service
synopses:
- Register-SmisProvider [-ConnectionUri] <Uri> [-Credential] <PSCredential> [[-AdditionalUsers]
  <String[]>] [[-CimSession] <CimSession>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AdditionalUsers,-Users String[]: ~
  -CimSession CimSession: ~
  -Confirm,-cf Switch: ~
  -ConnectionUri,-Uri Uri:
    required: true
  -Credential,-Creds PSCredential:
    required: true
  -Force Switch: ~
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
