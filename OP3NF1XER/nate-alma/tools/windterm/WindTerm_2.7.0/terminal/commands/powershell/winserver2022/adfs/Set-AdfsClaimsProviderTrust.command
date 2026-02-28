description: Sets the properties of a claims provider trust
synopses:
- Set-AdfsClaimsProviderTrust [-Name <String>] [-Identifier <String>] [-SignatureAlgorithm
  <String>] [-TokenSigningCertificate <X509Certificate2[]>] [-MetadataUrl <Uri>] [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-AllowCreate <Boolean>] [-AutoUpdateEnabled
  <Boolean>] [-CustomMFAUri <Uri>] [-SupportsMFA <Boolean>] [-WSFedEndpoint <Uri>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-OrganizationalAccountSuffix
  <String[]>] [-LookupForests <String[]>] [-AlternateLoginID <String>] [-Force] [-ClaimOffered
  <ClaimDescription[]>] [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>]
  [-RequiredNameIdFormat <Uri>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SigningCertificateRevocationCheck
  <String>] [-PromptLoginFederation <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType
  <String>] [-AnchorClaimType <String>] -TargetClaimsProviderTrust <ClaimsProviderTrust>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsClaimsProviderTrust [-Name <String>] [-Identifier <String>] [-SignatureAlgorithm
  <String>] [-TokenSigningCertificate <X509Certificate2[]>] [-MetadataUrl <Uri>] [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-AllowCreate <Boolean>] [-AutoUpdateEnabled
  <Boolean>] [-CustomMFAUri <Uri>] [-SupportsMFA <Boolean>] [-WSFedEndpoint <Uri>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-OrganizationalAccountSuffix
  <String[]>] [-LookupForests <String[]>] [-AlternateLoginID <String>] [-Force] [-ClaimOffered
  <ClaimDescription[]>] [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>]
  [-RequiredNameIdFormat <Uri>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SigningCertificateRevocationCheck
  <String>] [-PromptLoginFederation <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType
  <String>] [-AnchorClaimType <String>] -TargetCertificate <X509Certificate2> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsClaimsProviderTrust [-Name <String>] [-Identifier <String>] [-SignatureAlgorithm
  <String>] [-TokenSigningCertificate <X509Certificate2[]>] [-MetadataUrl <Uri>] [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-AllowCreate <Boolean>] [-AutoUpdateEnabled
  <Boolean>] [-CustomMFAUri <Uri>] [-SupportsMFA <Boolean>] [-WSFedEndpoint <Uri>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-OrganizationalAccountSuffix
  <String[]>] [-LookupForests <String[]>] [-AlternateLoginID <String>] [-Force] [-ClaimOffered
  <ClaimDescription[]>] [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>]
  [-RequiredNameIdFormat <Uri>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SigningCertificateRevocationCheck
  <String>] [-PromptLoginFederation <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType
  <String>] [-AnchorClaimType <String>] -TargetIdentifier <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsClaimsProviderTrust [-Name <String>] [-Identifier <String>] [-SignatureAlgorithm
  <String>] [-TokenSigningCertificate <X509Certificate2[]>] [-MetadataUrl <Uri>] [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-AllowCreate <Boolean>] [-AutoUpdateEnabled
  <Boolean>] [-CustomMFAUri <Uri>] [-SupportsMFA <Boolean>] [-WSFedEndpoint <Uri>]
  [-EncryptionCertificate <X509Certificate2>] [-EncryptionCertificateRevocationCheck
  <String>] [-MonitoringEnabled <Boolean>] [-Notes <String>] [-OrganizationalAccountSuffix
  <String[]>] [-LookupForests <String[]>] [-AlternateLoginID <String>] [-Force] [-ClaimOffered
  <ClaimDescription[]>] [-SamlEndpoint <SamlEndpoint[]>] [-ProtocolProfile <String>]
  [-RequiredNameIdFormat <Uri>] [-EncryptedNameIdRequired <Boolean>] [-SignedSamlRequestsRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SigningCertificateRevocationCheck
  <String>] [-PromptLoginFederation <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType
  <String>] [-AnchorClaimType <String>] -TargetName <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AcceptanceTransformRules String: ~
  -AcceptanceTransformRulesFile String: ~
  -AllowCreate Boolean: ~
  -AlternateLoginID String: ~
  -AnchorClaimType String: ~
  -AutoUpdateEnabled Boolean: ~
  -ClaimOffered ClaimDescription[]: ~
  -CustomMFAUri Uri: ~
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
  -Force Switch: ~
  -Identifier String: ~
  -LookupForests String[]: ~
  -MetadataUrl Uri: ~
  -MonitoringEnabled Boolean: ~
  -Name String: ~
  -Notes String: ~
  -OrganizationalAccountSuffix String[]: ~
  -PassThru Switch: ~
  -PromptLoginFallbackAuthenticationType String: ~
  -PromptLoginFederation PromptLoginFederation:
    values:
    - None
    - FallbackToProtocolSpecificParameters
    - ForwardPromptAndHintsOverWsFederation
    - Disabled
  -ProtocolProfile String:
    values:
    - WsFed-SAML
    - WSFederation
    - SAML
  -RequiredNameIdFormat Uri: ~
  -SamlAuthenticationRequestIndex UInt16: ~
  -SamlAuthenticationRequestParameters String:
    values:
    - Index
    - None
    - ''
    - ProtocolBinding
    - Url
    - UrlWithProtocolBinding
  -SamlAuthenticationRequestProtocolBinding String:
    values:
    - Artifact
    - ''
    - POST
    - Redirect
  -SamlEndpoint SamlEndpoint[]: ~
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
  -SupportsMFA Boolean: ~
  -TargetCertificate X509Certificate2:
    required: true
  -TargetClaimsProviderTrust ClaimsProviderTrust:
    required: true
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
  -TokenSigningCertificate X509Certificate2[]: ~
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
