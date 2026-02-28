description: Adds a new claims provider trust to the Federation Service
synopses:
- Add-AdfsClaimsProviderTrust -Name <String> -Identifier <String> -TokenSigningCertificate
  <X509Certificate2[]> [-AutoUpdateEnabled <Boolean>] [-AllowCreate <Boolean>] [-AnchorClaimType
  <String>] [-CustomMFAUri <Uri>] [-EncryptionCertificateRevocationCheck <String>]
  [-Enabled <Boolean>] [-Notes <String>] [-ProtocolProfile <String>] [-EncryptedNameIdRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SignatureAlgorithm
  <String>] [-SigningCertificateRevocationCheck <String>] [-SupportsMfa] [-PromptLoginFederation
  <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType <String>] [-RequiredNameIdFormat
  <Uri>] [-EncryptionCertificate <X509Certificate2>] [-OrganizationalAccountSuffix
  <String[]>] [-WSFedEndpoint <Uri>] [-ClaimOffered <ClaimDescription[]>] [-SamlEndpoint
  <SamlEndpoint[]>] [-SignedSamlRequestsRequired <Boolean>] [-PassThru] [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-MonitoringEnabled <Boolean>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsClaimsProviderTrust -Name <String> [-AutoUpdateEnabled <Boolean>] [-AllowCreate
  <Boolean>] [-AnchorClaimType <String>] [-EncryptionCertificateRevocationCheck <String>]
  [-Enabled <Boolean>] [-Notes <String>] [-ProtocolProfile <String>] [-EncryptedNameIdRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SignatureAlgorithm
  <String>] [-SigningCertificateRevocationCheck <String>] [-PromptLoginFederation
  <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType <String>] [-RequiredNameIdFormat
  <Uri>] [-OrganizationalAccountSuffix <String[]>] [-MetadataFile <String>] [-SignedSamlRequestsRequired
  <Boolean>] [-PassThru] [-AcceptanceTransformRules <String>] [-AcceptanceTransformRulesFile
  <String>] [-MonitoringEnabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsClaimsProviderTrust -Name <String> [-AutoUpdateEnabled <Boolean>] [-AllowCreate
  <Boolean>] [-AnchorClaimType <String>] [-EncryptionCertificateRevocationCheck <String>]
  [-Enabled <Boolean>] [-Notes <String>] [-ProtocolProfile <String>] [-EncryptedNameIdRequired
  <Boolean>] [-SamlAuthenticationRequestIndex <UInt16>] [-SamlAuthenticationRequestParameters
  <String>] [-SamlAuthenticationRequestProtocolBinding <String>] [-SignatureAlgorithm
  <String>] [-SigningCertificateRevocationCheck <String>] [-PromptLoginFederation
  <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType <String>] [-RequiredNameIdFormat
  <Uri>] [-OrganizationalAccountSuffix <String[]>] [-MetadataUrl <Uri>] [-SignedSamlRequestsRequired
  <Boolean>] [-PassThru] [-AcceptanceTransformRules <String>] [-AcceptanceTransformRulesFile
  <String>] [-MonitoringEnabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptanceTransformRules String: ~
  -AcceptanceTransformRulesFile String: ~
  -AllowCreate Boolean: ~
  -AnchorClaimType String: ~
  -AutoUpdateEnabled Boolean: ~
  -ClaimOffered ClaimDescription[]: ~
  -CustomMFAUri Uri: ~
  -Enabled Boolean: ~
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
  -Identifier String:
    required: true
  -MetadataFile String: ~
  -MetadataUrl Uri: ~
  -MonitoringEnabled Boolean: ~
  -Name String:
    required: true
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
    - WSFederation
    - WsFed-SAML
    - SAML
  -RequiredNameIdFormat Uri: ~
  -SamlAuthenticationRequestIndex UInt16: ~
  -SamlAuthenticationRequestParameters String:
    values:
    - Index
    - None
    - ProtocolBinding
    - Url
    - UrlWithProtocolBinding
  -SamlAuthenticationRequestProtocolBinding String:
    values:
    - Artifact
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
  -SupportsMfa Switch: ~
  -TokenSigningCertificate X509Certificate2[]:
    required: true
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
