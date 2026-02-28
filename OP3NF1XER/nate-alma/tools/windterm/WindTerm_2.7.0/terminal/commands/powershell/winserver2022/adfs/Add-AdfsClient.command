description: Registers an OAuth 2.0 client with AD FS
synopses:
- Add-AdfsClient [-ClientId] <String> [-Name] <String> [[-RedirectUri] <String[]>]
  [-Description <String>] [-ClientType <ClientType>] [-ADUserPrincipalName <String>]
  [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-JWKSUri <Uri>] [-JWKSFile <String>] [-LogoutUri <String>]
  [-GenerateClientSecret] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADUserPrincipalName String: ~
  -ClientId String:
    required: true
  -ClientType ClientType:
    values:
    - Public
    - Confidential
  -Description String: ~
  -GenerateClientSecret Switch: ~
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
