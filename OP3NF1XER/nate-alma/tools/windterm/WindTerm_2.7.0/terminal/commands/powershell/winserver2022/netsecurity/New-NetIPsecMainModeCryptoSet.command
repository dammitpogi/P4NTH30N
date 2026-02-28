description: Creates a main mode cryptographic set that contains suites of cryptographic
  protocols to offer in IPsec main mode negotiations with other computers
synopses:
- New-NetIPsecMainModeCryptoSet [-PolicyStore <String>] [-GPOSession <String>] [-Name
  <String>] -DisplayName <String> [-Description <String>] [-Group <String>] -Proposal
  <CimInstance[]> [-MaxMinutes <UInt32>] [-MaxSessions <UInt32>] [-ForceDiffieHellman
  <Boolean>] [-Default] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Default Switch: ~
  -Description String: ~
  -DisplayName String:
    required: true
  -ForceDiffieHellman Boolean: ~
  -GPOSession String: ~
  -Group String: ~
  -MaxMinutes UInt32: ~
  -MaxSessions UInt32: ~
  -Name,-ID String: ~
  -PolicyStore String: ~
  -Proposal CimInstance[]:
    required: true
  -ThrottleLimit Int32: ~
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
