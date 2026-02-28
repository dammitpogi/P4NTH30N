description: Sets the properties of a relying party trust
synopses:
- Set-AdfsRelyingPartyTrust [-AllowedAuthenticationClassReferences <String[]>] [-Name
  <String>] [-NotBeforeSkew <Int32>] [-EnableJWT <Boolean>] [-Identifier <String[]>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-EncryptClaims <Boolean>] [-MetadataUrl <Uri>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules
  <String>] [-DelegationAuthorizationRulesFile <String>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-AutoUpdateEnabled <Boolean>]
  [-WSFedEndpoint <Uri>] [-AdditionalWSFedEndpoint <String[]>] [-ClaimsProviderName
  <String[]>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-ClaimAccepted <ClaimDescription[]>]
  [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>] [-RequestSigningCertificate
  <X509Certificate2[]>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlResponseSignature <String>] [-SignatureAlgorithm <String>] [-SigningCertificateRevocationCheck
  <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication <Boolean>] [-AllowedClientTypes
  <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo <RefreshTokenIssuanceDeviceTypes>]
  [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders <Boolean>]
  -TargetIdentifier <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsRelyingPartyTrust [-AllowedAuthenticationClassReferences <String[]>] [-Name
  <String>] [-NotBeforeSkew <Int32>] [-EnableJWT <Boolean>] [-Identifier <String[]>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-EncryptClaims <Boolean>] [-MetadataUrl <Uri>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules
  <String>] [-DelegationAuthorizationRulesFile <String>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-AutoUpdateEnabled <Boolean>]
  [-WSFedEndpoint <Uri>] [-AdditionalWSFedEndpoint <String[]>] [-ClaimsProviderName
  <String[]>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-ClaimAccepted <ClaimDescription[]>]
  [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>] [-RequestSigningCertificate
  <X509Certificate2[]>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlResponseSignature <String>] [-SignatureAlgorithm <String>] [-SigningCertificateRevocationCheck
  <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication <Boolean>] [-AllowedClientTypes
  <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo <RefreshTokenIssuanceDeviceTypes>]
  [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders <Boolean>]
  -TargetRelyingParty <RelyingPartyTrust> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsRelyingPartyTrust [-AllowedAuthenticationClassReferences <String[]>] [-Name
  <String>] [-NotBeforeSkew <Int32>] [-EnableJWT <Boolean>] [-Identifier <String[]>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-EncryptClaims <Boolean>] [-MetadataUrl <Uri>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules
  <String>] [-DelegationAuthorizationRulesFile <String>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-AutoUpdateEnabled <Boolean>]
  [-WSFedEndpoint <Uri>] [-AdditionalWSFedEndpoint <String[]>] [-ClaimsProviderName
  <String[]>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-ClaimAccepted <ClaimDescription[]>]
  [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>] [-RequestSigningCertificate
  <X509Certificate2[]>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlResponseSignature <String>] [-SignatureAlgorithm <String>] [-SigningCertificateRevocationCheck
  <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication <Boolean>] [-AllowedClientTypes
  <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo <RefreshTokenIssuanceDeviceTypes>]
  [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders <Boolean>]
  -TargetName <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -AlwaysRequireAuthentication Boolean: ~
  -AutoUpdateEnabled Boolean: ~
  -ClaimAccepted ClaimDescription[]: ~
  -ClaimsProviderName String[]: ~
  -DelegationAuthorizationRules String: ~
  -DelegationAuthorizationRulesFile String: ~
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
  -Identifier String[]: ~
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
  -MetadataUrl Uri: ~
  -MonitoringEnabled Boolean: ~
  -Name String: ~
  -NotBeforeSkew Int32: ~
  -Notes String: ~
  -PassThru Switch: ~
  -ProtocolProfile String:
    values:
    - WsFed-SAML
    - WSFederation
    - SAML
  -RefreshTokenProtectionEnabled Boolean: ~
  -RequestMFAFromClaimsProviders Boolean: ~
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
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
  -TargetRelyingParty RelyingPartyTrust:
    required: true
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
