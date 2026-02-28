description: Adds a new relying party trust to the Federation Service
synopses:
- Add-AdfsRelyingPartyTrust -Name <String> -Identifier <String[]> [-EncryptClaims
  <Boolean>] [-Enabled <Boolean>] [-EncryptionCertificate <X509Certificate2>] [-AutoUpdateEnabled
  <Boolean>] [-WSFedEndpoint <Uri>] [-AdditionalWSFedEndpoint <String[]>] [-ClaimAccepted
  <ClaimDescription[]>] [-SamlEndpoint <SamlEndpoint[]>] [-RequestSigningCertificate
  <X509Certificate2[]>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-Notes <String>] [-SignatureAlgorithm <String>] [-SigningCertificateRevocationCheck
  <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication] [-RequestMFAFromClaimsProviders]
  [-AllowedAuthenticationClassReferences <String[]>] [-EncryptionCertificateRevocationCheck
  <String>] [-NotBeforeSkew <Int32>] [-ProtocolProfile <String>] [-ClaimsProviderName
  <String[]>] [-EnableJWT <Boolean>] [-SamlResponseSignature <String>] [-AllowedClientTypes
  <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo <RefreshTokenIssuanceDeviceTypes>]
  [-RefreshTokenProtectionEnabled <Boolean>] [-PassThru] [-MonitoringEnabled <Boolean>]
  [-ImpersonationAuthorizationRules <String>] [-ImpersonationAuthorizationRulesFile
  <String>] [-IssuanceTransformRules <String>] [-IssuanceTransformRulesFile <String>]
  [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile <String>]
  [-DelegationAuthorizationRules <String>] [-DelegationAuthorizationRulesFile <String>]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-AdfsRelyingPartyTrust -Name <String> -MetadataFile <String> [-EncryptClaims
  <Boolean>] [-Enabled <Boolean>] [-AutoUpdateEnabled <Boolean>] [-EncryptedNameIdRequired
  <Boolean>] [-SignedSamlRequestsRequired <Boolean>] [-Notes <String>] [-SignatureAlgorithm
  <String>] [-SigningCertificateRevocationCheck <String>] [-TokenLifetime <Int32>]
  [-AlwaysRequireAuthentication] [-RequestMFAFromClaimsProviders] [-AllowedAuthenticationClassReferences
  <String[]>] [-EncryptionCertificateRevocationCheck <String>] [-NotBeforeSkew <Int32>]
  [-ProtocolProfile <String>] [-ClaimsProviderName <String[]>] [-EnableJWT <Boolean>]
  [-SamlResponseSignature <String>] [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo
  <RefreshTokenIssuanceDeviceTypes>] [-RefreshTokenProtectionEnabled <Boolean>] [-PassThru]
  [-MonitoringEnabled <Boolean>] [-ImpersonationAuthorizationRules <String>] [-ImpersonationAuthorizationRulesFile
  <String>] [-IssuanceTransformRules <String>] [-IssuanceTransformRulesFile <String>]
  [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile <String>]
  [-DelegationAuthorizationRules <String>] [-DelegationAuthorizationRulesFile <String>]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-AdfsRelyingPartyTrust -Name <String> -MetadataUrl <Uri> [-EncryptClaims <Boolean>]
  [-Enabled <Boolean>] [-AutoUpdateEnabled <Boolean>] [-EncryptedNameIdRequired <Boolean>]
  [-SignedSamlRequestsRequired <Boolean>] [-Notes <String>] [-SignatureAlgorithm <String>]
  [-SigningCertificateRevocationCheck <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication]
  [-RequestMFAFromClaimsProviders] [-AllowedAuthenticationClassReferences <String[]>]
  [-EncryptionCertificateRevocationCheck <String>] [-NotBeforeSkew <Int32>] [-ProtocolProfile
  <String>] [-ClaimsProviderName <String[]>] [-EnableJWT <Boolean>] [-SamlResponseSignature
  <String>] [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo
  <RefreshTokenIssuanceDeviceTypes>] [-RefreshTokenProtectionEnabled <Boolean>] [-PassThru]
  [-MonitoringEnabled <Boolean>] [-ImpersonationAuthorizationRules <String>] [-ImpersonationAuthorizationRulesFile
  <String>] [-IssuanceTransformRules <String>] [-IssuanceTransformRulesFile <String>]
  [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile <String>]
  [-DelegationAuthorizationRules <String>] [-DelegationAuthorizationRulesFile <String>]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AdditionalWSFedEndpoint String[]: ~
  -AllowedAuthenticationClassReferences String[]: ~
  -AllowedClientTypes AllowedClientTypes:
    values:
    - None
    - Public
    - Confidential
  -AlwaysRequireAuthentication Switch: ~
  -AutoUpdateEnabled Boolean: ~
  -ClaimAccepted ClaimDescription[]: ~
  -ClaimsProviderName String[]: ~
  -DelegationAuthorizationRules String: ~
  -DelegationAuthorizationRulesFile String: ~
  -Enabled Boolean: ~
  -EnableJWT Boolean: ~
  -EncryptClaims Boolean: ~
  -EncryptedNameIdRequired Boolean: ~
  -EncryptionCertificate X509Certificate2: ~
  -EncryptionCertificateRevocationCheck String:
    values:
    - CheckChain
    - CheckChainCacheOnly
    - CheckChainExcludeRoot
    - CheckChainExcludeRootCacheOnly
    - CheckEndCert
    - CheckEndCertCacheOnly
    - None
  -Identifier String[]:
    required: true
  -ImpersonationAuthorizationRules String: ~
  -ImpersonationAuthorizationRulesFile String: ~
  -IssuanceAuthorizationRules String: ~
  -IssuanceAuthorizationRulesFile String: ~
  -IssuanceTransformRules String: ~
  -IssuanceTransformRulesFile String: ~
  -IssueOAuthRefreshTokensTo RefreshTokenIssuanceDeviceTypes:
    values:
    - NoDevice
    - WorkplaceJoinedDevices
    - AllDevices
  -MetadataFile String:
    required: true
  -MetadataUrl Uri:
    required: true
  -MonitoringEnabled Boolean: ~
  -Name String:
    required: true
  -NotBeforeSkew Int32: ~
  -Notes String: ~
  -PassThru Switch: ~
  -ProtocolProfile String:
    values:
    - WsFed-SAML
    - WSFederation
    - SAML
  -RefreshTokenProtectionEnabled Boolean: ~
  -RequestMFAFromClaimsProviders Switch: ~
  -RequestSigningCertificate X509Certificate2[]: ~
  -SamlEndpoint SamlEndpoint[]: ~
  -SamlResponseSignature String:
    values:
    - AssertionOnly
    - MessageAndAssertion
    - MessageOnly
  -SignatureAlgorithm String: ~
  -SignedSamlRequestsRequired Boolean: ~
  -SigningCertificateRevocationCheck String:
    values:
    - CheckChain
    - CheckChainCacheOnly
    - CheckChainExcludeRoot
    - CheckChainExcludeRootCacheOnly
    - CheckEndCert
    - CheckEndCertCacheOnly
    - None
  -TokenLifetime Int32: ~
  -WSFedEndpoint Uri: ~
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
