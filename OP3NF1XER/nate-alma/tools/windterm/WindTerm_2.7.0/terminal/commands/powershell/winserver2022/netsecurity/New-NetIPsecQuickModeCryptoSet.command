description: Creates a quick mode cryptographic set that contains suites of cryptographic
  protocols to offer in IPsec quick mode negotiations with other computers
synopses:
- New-NetIPsecQuickModeCryptoSet [-PolicyStore <String>] [-GPOSession <String>] [-Name
  <String>] -DisplayName <String> [-Description <String>] [-Group <String>] -Proposal
  <CimInstance[]> [-PerfectForwardSecrecyGroup <DiffieHellmanGroup>] [-Default] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Default Switch: ~
  -Description String: ~
  -DisplayName String:
    required: true
  -GPOSession String: ~
  -Group String: ~
  -Name,-ID String: ~
  -PerfectForwardSecrecyGroup,-PfsGroup DiffieHellmanGroup:
    values:
    - None
    - DH1
    - DH2
    - DH14
    - DH19
    - DH20
    - DH24
    - SameAsMainMode
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
