description: Sets the properties that control global behaviors in AD FS
synopses:
- Set-AdfsProperties [-AuthenticationContextOrder <Uri[]>] [-AcceptableIdentifiers
  <Uri[]>] [-AddProxyAuthorizationRules <String>] [-ArtifactDbConnection <String>]
  [-AuditLevel <String[]>] [-AutoCertificateRollover <Boolean>] [-CertificateCriticalThreshold
  <Int32>] [-CertificateDuration <Int32>] [-CertificateGenerationThreshold <Int32>]
  [-CertificatePromotionThreshold <Int32>] [-CertificateRolloverInterval <Int32>]
  [-CertificateThresholdMultiplier <Int32>] [-ClientCertRevocationCheck <String>]
  [-ContactPerson <ContactPerson>] [-DisplayName <String>] [-EnableOAuthDeviceFlow
  <Boolean>] [-EnableOAuthLogout <Boolean>] [-FederationPassiveAddress <String>] [-HostName
  <String>] [-HttpPort <Int32>] [-HttpsPort <Int32>] [-IntranetUseLocalClaimsProvider
  <Boolean>] [-TlsClientPort <Int32>] [-Identifier <Uri>] [-LogLevel <String[]>] [-MonitoringInterval
  <Int32>] [-NetTcpPort <Int32>] [-NtlmOnlySupportedClientAtProxy <Boolean>] [-OrganizationInfo
  <Organization>] [-PreventTokenReplays <Boolean>] [-ExtendedProtectionTokenCheck
  <String>] [-ProxyTrustTokenLifetime <Int32>] [-ReplayCacheExpirationInterval <Int32>]
  [-SignedSamlRequestsRequired <Boolean>] [-SamlMessageDeliveryWindow <Int32>] [-SignSamlAuthnRequests
  <Boolean>] [-SsoLifetime <Int32>] [-SsoEnabled <Boolean>] [-PersistentSsoLifetimeMins
  <Int32>] [-KmsiLifetimeMins <Int32>] [-EnablePersistentSso <Boolean>] [-PersistentSsoCutoffTime
  <DateTime>] [-EnableKmsi <Boolean>] [-WIASupportedUserAgents <String[]>] [-BrowserSsoSupportedUserAgents
  <String[]>] [-BrowserSsoEnabled <Boolean>] [-LoopDetectionTimeIntervalInSeconds
  <Int32>] [-LoopDetectionMaximumTokensIssuedInInterval <Int32>] [-EnableLoopDetection
  <Boolean>] [-ExtranetLockoutMode <String>] [-ExtranetLockoutThreshold <Int32>] [-EnableExtranetLockout
  <Boolean>] [-ExtranetObservationWindow <TimeSpan>] [-ExtranetLockoutRequirePDC <Boolean>]
  [-SendClientRequestIdAsQueryStringParameter <Boolean>] [-GlobalRelyingPartyClaimsIssuancePolicy
  <String>] [-EnableLocalAuthenticationTypes <Boolean>] [-EnableRelayStateForIdpInitiatedSignOn
  <Boolean>] [-DelegateServiceAdministration <String>] [-AllowSystemServiceAdministration
  <Boolean>] [-AllowLocalAdminsServiceAdministration <Boolean>] [-DeviceUsageWindowInDays
  <Int32>] [-EnableIdPInitiatedSignonPage <Boolean>] [-IgnoreTokenBinding <Boolean>]
  [-IdTokenIssuer <Uri>] [-PromptLoginFederation <PromptLoginFederation>] [-PromptLoginFallbackAuthenticationType
  <String>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptableIdentifiers Uri[]: ~
  -AddProxyAuthorizationRules String: ~
  -AllowLocalAdminsServiceAdministration Boolean: ~
  -AllowSystemServiceAdministration Boolean: ~
  -ArtifactDbConnection String: ~
  -AuditLevel String[]:
    values:
    - None
    - Basic
    - Verbose
  -AuthenticationContextOrder Uri[]: ~
  -AutoCertificateRollover Boolean: ~
  -BrowserSsoEnabled Boolean: ~
  -BrowserSsoSupportedUserAgents String[]: ~
  -CertificateCriticalThreshold Int32: ~
  -CertificateDuration Int32: ~
  -CertificateGenerationThreshold Int32: ~
  -CertificatePromotionThreshold Int32: ~
  -CertificateRolloverInterval Int32: ~
  -CertificateThresholdMultiplier Int32: ~
  -ClientCertRevocationCheck String:
    values:
    - CheckChain
    - CheckChainCacheOnly
    - CheckChainExcludeRoot
    - CheckChainExcludeRootCacheOnly
    - CheckEndCert
    - CheckEndCertCacheOnly
    - None
  -ContactPerson ContactPerson: ~
  -DelegateServiceAdministration String: ~
  -DeviceUsageWindowInDays Int32: ~
  -DisplayName String: ~
  -EnableExtranetLockout Boolean: ~
  -EnableIdPInitiatedSignonPage Boolean: ~
  -EnableKmsi Boolean: ~
  -EnableLocalAuthenticationTypes Boolean: ~
  -EnableLoopDetection Boolean: ~
  -EnableOAuthDeviceFlow Boolean: ~
  -EnableOAuthLogout Boolean: ~
  -EnablePersistentSso Boolean: ~
  -EnableRelayStateForIdpInitiatedSignOn Boolean: ~
  -ExtendedProtectionTokenCheck String:
    values:
    - Allow
    - Require
    - None
  '-ExtranetLockoutMode: String':
    values:
    - ADPasswordCounter
    - ADFSSmartLockoutLogOnly
    - ADFSSmartLockoutEnforce
  -ExtranetLockoutRequirePDC Boolean: ~
  -ExtranetLockoutThreshold Int32: ~
  -ExtranetObservationWindow TimeSpan: ~
  -FederationPassiveAddress String: ~
  -Force Switch: ~
  -GlobalRelyingPartyClaimsIssuancePolicy String: ~
  -HostName String: ~
  -HttpPort Int32: ~
  -HttpsPort Int32: ~
  -Identifier Uri: ~
  -IdTokenIssuer Uri: ~
  -IgnoreTokenBinding Boolean: ~
  -IntranetUseLocalClaimsProvider Boolean: ~
  -KmsiLifetimeMins Int32: ~
  -LogLevel String[]:
    values:
    - Errors
    - FailureAudits
    - Information
    - Verbose
    - None
    - SuccessAudits
    - Warnings
  -LoopDetectionMaximumTokensIssuedInInterval Int32: ~
  -LoopDetectionTimeIntervalInSeconds Int32: ~
  -MonitoringInterval Int32: ~
  -NetTcpPort Int32: ~
  -NtlmOnlySupportedClientAtProxy Boolean: ~
  -OrganizationInfo Organization: ~
  -PassThru Switch: ~
  -PersistentSsoCutoffTime DateTime: ~
  -PersistentSsoLifetimeMins Int32: ~
  -PreventTokenReplays Boolean: ~
  -PromptLoginFallbackAuthenticationType String: ~
  -PromptLoginFederation PromptLoginFederation:
    values:
    - None
    - FallbackToProtocolSpecificParameters
    - ForwardPromptAndHintsOverWsFederation
    - Disabled
  -ProxyTrustTokenLifetime Int32: ~
  -ReplayCacheExpirationInterval Int32: ~
  -SamlMessageDeliveryWindow Int32: ~
  -SendClientRequestIdAsQueryStringParameter Boolean: ~
  -SignedSamlRequestsRequired Boolean: ~
  -SignSamlAuthnRequests Boolean: ~
  -SsoEnabled Boolean: ~
  -SsoLifetime Int32: ~
  -TlsClientPort Int32: ~
  -WIASupportedUserAgents String[]: ~
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
