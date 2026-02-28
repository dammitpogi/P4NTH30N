description: Generates an XML file with the specified EAP configuration
synopses:
- New-EapConfiguration [-UseWinlogonCredential] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-EapConfiguration [-UseWinlogonCredential] [-Ttls] [-TunneledNonEapAuthMethod
  <String>] [[-TunneledEapAuthMethod] <XmlDocument>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-EapConfiguration [-Tls] [-UserCertificate] [-VerifyServerIdentity] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-EapConfiguration [-VerifyServerIdentity] [[-TunneledEapAuthMethod] <XmlDocument>]
  [-Peap] [-EnableNap] [-FastReconnect <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EnableNap Switch: ~
  -FastReconnect Boolean: ~
  -Peap Switch:
    required: true
  -ThrottleLimit Int32: ~
  -Tls Switch:
    required: true
  -Ttls Switch:
    required: true
  -TunneledEapAuthMethod,-TunneledEapAuthMethod XmlDocument: ~
  -TunneledNonEapAuthMethod,-TunneledNonEapAuthMethod String:
    values:
    - Pap
    - Chap
    - MSChap
    - MSChapv2
  -UseWinlogonCredential Switch: ~
  -UserCertificate Switch: ~
  -VerifyServerIdentity Switch: ~
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
