description: Configures Web Application Proxy on the server
synopses:
- Install-WebApplicationProxy -FederationServiceTrustCredential <PSCredential> -CertificateThumbprint
  <String> -FederationServiceName <String> [-HttpsPort <Int32>] [-TlsClientPort <Int32>]
  [-ForwardProxy <String>] [<CommonParameters>]
options:
  -CertificateThumbprint String:
    required: true
  -FederationServiceName String:
    required: true
  -FederationServiceTrustCredential PSCredential:
    required: true
  -ForwardProxy String: ~
  -HttpsPort Int32: ~
  -TlsClientPort Int32: ~
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
