description: Modifies configuration settings for a Web API application in AD FS
synopses:
- Set-AdfsWebApiApplication [-TargetIdentifier] <String> [-AllowedAuthenticationClassReferences
  <String[]>] [-AlwaysRequireAuthentication <Boolean>] [-ClaimsProviderName <String[]>]
  [-Name <String>] [-NotBeforeSkew <Int32>] [-Identifier <String[]>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules
  <String>] [-DelegationAuthorizationRulesFile <String>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-Description <String>] [-TokenLifetime
  <Int32>] [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo
  <RefreshTokenIssuanceDeviceTypes>] [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders
  <Boolean>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsWebApiApplication [-TargetName] <String> [-AllowedAuthenticationClassReferences
  <String[]>] [-AlwaysRequireAuthentication <Boolean>] [-ClaimsProviderName <String[]>]
  [-Name <String>] [-NotBeforeSkew <Int32>] [-Identifier <String[]>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules
  <String>] [-DelegationAuthorizationRulesFile <String>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-Description <String>] [-TokenLifetime
  <Int32>] [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo
  <RefreshTokenIssuanceDeviceTypes>] [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders
  <Boolean>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsWebApiApplication [-TargetApplication] <WebApiApplication> [-AllowedAuthenticationClassReferences
  <String[]>] [-AlwaysRequireAuthentication <Boolean>] [-ClaimsProviderName <String[]>]
  [-Name <String>] [-NotBeforeSkew <Int32>] [-Identifier <String[]>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules
  <String>] [-DelegationAuthorizationRulesFile <String>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-Description <String>] [-TokenLifetime
  <Int32>] [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo
  <RefreshTokenIssuanceDeviceTypes>] [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders
  <Boolean>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AllowedAuthenticationClassReferences String[]: ~
  -AllowedClientTypes AllowedClientTypes:
    values:
    - None
    - Public
    - Confidential
  -AlwaysRequireAuthentication Boolean: ~
  -ClaimsProviderName String[]: ~
  -DelegationAuthorizationRules String: ~
  -DelegationAuthorizationRulesFile String: ~
  -Description String: ~
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
  -Name String: ~
  -NotBeforeSkew Int32: ~
  -PassThru Switch: ~
  -RefreshTokenProtectionEnabled Boolean: ~
  -RequestMFAFromClaimsProviders Boolean: ~
  -TargetApplication WebApiApplication:
    required: true
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
  -TokenLifetime Int32: ~
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
