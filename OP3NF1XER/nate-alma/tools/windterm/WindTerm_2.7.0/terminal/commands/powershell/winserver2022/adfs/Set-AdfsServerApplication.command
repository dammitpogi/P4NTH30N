description: Modifies configuration settings for a server application role of an application
  in AD FS
synopses:
- Set-AdfsServerApplication [-TargetIdentifier] <String> [-Identifier <String>] [-Name
  <String>] [-RedirectUri <String[]>] [-Description <String>] [-ADUserPrincipalName
  <String>] [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-ChangeClientSecret] [-ResetClientSecret] [-JWKSUri <Uri>]
  [-ReloadJWTSigningKeys] [-JWKSFile <String>] [-LogoutUri <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsServerApplication [-TargetName] <String> [-Identifier <String>] [-Name <String>]
  [-RedirectUri <String[]>] [-Description <String>] [-ADUserPrincipalName <String>]
  [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-ChangeClientSecret] [-ResetClientSecret] [-JWKSUri <Uri>]
  [-ReloadJWTSigningKeys] [-JWKSFile <String>] [-LogoutUri <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsServerApplication [-TargetApplication] <ServerApplication> [-Identifier
  <String>] [-Name <String>] [-RedirectUri <String[]>] [-Description <String>] [-ADUserPrincipalName
  <String>] [-JWTSigningCertificate <X509Certificate2[]>] [-JWTSigningCertificateRevocationCheck
  <RevocationSetting>] [-ChangeClientSecret] [-ResetClientSecret] [-JWKSUri <Uri>]
  [-ReloadJWTSigningKeys] [-JWKSFile <String>] [-LogoutUri <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -ADUserPrincipalName String: ~
  -ChangeClientSecret Switch: ~
  -Description String: ~
  -Identifier String: ~
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
  -TargetApplication ServerApplication:
    required: true
  -TargetIdentifier String:
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
