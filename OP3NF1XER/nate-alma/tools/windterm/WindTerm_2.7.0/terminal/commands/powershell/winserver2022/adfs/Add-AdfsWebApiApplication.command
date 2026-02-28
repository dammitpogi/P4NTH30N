description: Adds a Web API application role to an application in AD FS
synopses:
- Add-AdfsWebApiApplication [-ApplicationGroupIdentifier] <String> -Name <String>
  -Identifier <String[]> [-AllowedAuthenticationClassReferences <String[]>] [-ClaimsProviderName
  <String[]>] [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile
  <String>] [-DelegationAuthorizationRules <String>] [-DelegationAuthorizationRulesFile
  <String>] [-ImpersonationAuthorizationRules <String>] [-ImpersonationAuthorizationRulesFile
  <String>] [-IssuanceTransformRules <String>] [-IssuanceTransformRulesFile <String>]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-NotBeforeSkew
  <Int32>] [-Description <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication]
  [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo <RefreshTokenIssuanceDeviceTypes>]
  [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsWebApiApplication [-ApplicationGroup] <ApplicationGroup> -Name <String>
  -Identifier <String[]> [-AllowedAuthenticationClassReferences <String[]>] [-ClaimsProviderName
  <String[]>] [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile
  <String>] [-DelegationAuthorizationRules <String>] [-DelegationAuthorizationRulesFile
  <String>] [-ImpersonationAuthorizationRules <String>] [-ImpersonationAuthorizationRulesFile
  <String>] [-IssuanceTransformRules <String>] [-IssuanceTransformRulesFile <String>]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-NotBeforeSkew
  <Int32>] [-Description <String>] [-TokenLifetime <Int32>] [-AlwaysRequireAuthentication]
  [-AllowedClientTypes <AllowedClientTypes>] [-IssueOAuthRefreshTokensTo <RefreshTokenIssuanceDeviceTypes>]
  [-RefreshTokenProtectionEnabled <Boolean>] [-RequestMFAFromClaimsProviders] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -AlwaysRequireAuthentication Switch: ~
  -ApplicationGroup ApplicationGroup:
    required: true
  -ApplicationGroupIdentifier String:
    required: true
  -ClaimsProviderName String[]: ~
  -DelegationAuthorizationRules String: ~
  -DelegationAuthorizationRulesFile String: ~
  -Description String: ~
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
  -Name String:
    required: true
  -NotBeforeSkew Int32: ~
  -PassThru Switch: ~
  -RefreshTokenProtectionEnabled Boolean: ~
  -RequestMFAFromClaimsProviders Switch: ~
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
