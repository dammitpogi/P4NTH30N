description: Sets the properties of a relying party trust for a non-claims-aware web
  application or service
synopses:
- Set-AdfsNonClaimsAwareRelyingPartyTrust [-AlwaysRequireAuthentication] [-Identifier
  <String[]>] [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile
  <String>] [-Name <String>] [-Notes <String>] [-PassThru] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-ClaimsProviderName <String[]>]
  [-TargetName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsNonClaimsAwareRelyingPartyTrust [-AlwaysRequireAuthentication] [-Identifier
  <String[]>] [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile
  <String>] [-Name <String>] [-Notes <String>] [-PassThru] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-ClaimsProviderName <String[]>]
  -TargetIdentifier <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsNonClaimsAwareRelyingPartyTrust [-AlwaysRequireAuthentication] [-Identifier
  <String[]>] [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile
  <String>] [-Name <String>] [-Notes <String>] [-PassThru] [-AdditionalAuthenticationRules
  <String>] [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-ClaimsProviderName <String[]>]
  -TargetNonClaimsAwareRelyingPartyTrust <NonClaimsAwareRelyingPartyTrust> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AlwaysRequireAuthentication Switch: ~
  -ClaimsProviderName String[]: ~
  -Identifier String[]: ~
  -IssuanceAuthorizationRules String: ~
  -IssuanceAuthorizationRulesFile String: ~
  -Name String: ~
  -Notes String: ~
  -PassThru Switch: ~
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
  -TargetNonClaimsAwareRelyingPartyTrust NonClaimsAwareRelyingPartyTrust:
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
