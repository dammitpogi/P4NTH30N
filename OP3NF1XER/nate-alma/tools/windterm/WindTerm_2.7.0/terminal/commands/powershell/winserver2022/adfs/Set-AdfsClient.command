description: Modifies registration settings for an OAuth 2.0 client registered with
  AD FS
synopses:
- Set-AdfsClient [-Force] [-TargetName] <String> [-ClientId <String>] [-Name <String>]
  [-RedirectUri <String[]>] [-Description <String>] [-ADUserPrincipalName <String>]
  [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-ChangeClientSecret] [-ResetClientSecret] [-JWKSUri <Uri>]
  [-ReloadJWTSigningKeys] [-JWKSFile <String>] [-LogoutUri <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsClient [-Force] [-TargetClientId] <String> [-ClientId <String>] [-Name <String>]
  [-RedirectUri <String[]>] [-Description <String>] [-ADUserPrincipalName <String>]
  [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-ChangeClientSecret] [-ResetClientSecret] [-JWKSUri <Uri>]
  [-ReloadJWTSigningKeys] [-JWKSFile <String>] [-LogoutUri <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsClient [-Force] [-TargetClient] <AdfsClient> [-ClientId <String>] [-Name
  <String>] [-RedirectUri <String[]>] [-Description <String>] [-ADUserPrincipalName
  <String>] [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-ChangeClientSecret] [-ResetClientSecret] [-JWKSUri <Uri>]
  [-ReloadJWTSigningKeys] [-JWKSFile <String>] [-LogoutUri <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -ADUserPrincipalName String: ~
  -ChangeClientSecret Switch: ~
  -ClientId String: ~
  -Description String: ~
  -Force Switch: ~
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
  -Name String: ~
  -PassThru Switch: ~
  -RedirectUri String[]: ~
  -ReloadJWTSigningKeys Switch: ~
  -ResetClientSecret Switch: ~
  -TargetClient AdfsClient:
    required: true
  -TargetClientId String:
    required: true
  -TargetName String:
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
