description: Configures the authentication method for incoming site-to-site (S2S)
  VPN interfaces on a Routing and Remote Access (RRAS) server
synopses:
- Set-VpnAuthProtocol [-UserAuthProtocolAccepted <String[]>] [-TunnelAuthProtocolsAdvertised
  <String>] [-RootCertificateNameToAccept <X509Certificate2>] [-CertificateAdvertised
  <X509Certificate2>] [-SharedSecret <String>] [-PassThru] [-CertificateEKUsToAccept
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CertificateAdvertised X509Certificate2: ~
  -CertificateEKUsToAccept String[]: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -PassThru Switch: ~
  -RootCertificateNameToAccept X509Certificate2: ~
  -SharedSecret String: ~
  -ThrottleLimit Int32: ~
  -TunnelAuthProtocolsAdvertised String:
    values:
    - Certificates
    - PreSharedKey
  -UserAuthProtocolAccepted String[]:
    values:
    - EAP
    - Certificate
    - MsChapv2
    - Chap
    - PAP
    - PreSharedKey
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
