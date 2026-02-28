description: Adds a server application role to an application in AD FS
synopses:
- Add-AdfsServerApplication [-ApplicationGroupIdentifier] <String> [-Name] <String>
  [-Identifier] <String> [[-RedirectUri] <String[]>] [-Description <String>] [-ADUserPrincipalName
  <String>] [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-JWKSUri <Uri>] [-LogoutUri <String>] [-JWKSFile <String>]
  [-GenerateClientSecret] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsServerApplication [-ApplicationGroup] <ApplicationGroup> [-Name] <String>
  [-Identifier] <String> [[-RedirectUri] <String[]>] [-Description <String>] [-ADUserPrincipalName
  <String>] [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-JWKSUri <Uri>] [-LogoutUri <String>] [-JWKSFile <String>]
  [-GenerateClientSecret] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADUserPrincipalName String: ~
  -ApplicationGroup ApplicationGroup:
    required: true
  -ApplicationGroupIdentifier String:
    required: true
  -Description String: ~
  -GenerateClientSecret Switch: ~
  -Identifier String:
    required: true
  -JWKSFile String: ~
  -JWKSUri Uri: ~
  -JWTSigningCertificate X509Certificate2[]: ~
  -JWTSigningCertificateRevocationCheck RevocationSetting:
    values:
    - None
    - CheckEndCert
    - CheckEndCertCacheOnly
    - CheckChain
    - CheckChainCacheOnly
    - CheckChainExcludeRoot
    - CheckChainExcludeRootCacheOnly
  -LogoutUri String: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -RedirectUri String[]: ~
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
