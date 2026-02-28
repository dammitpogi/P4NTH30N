description: Adds a relying party trust that represents a non-claims-aware web application
  or service to the Federation Service
synopses:
- Add-AdfsNonClaimsAwareRelyingPartyTrust [-Name] <String> [-Identifier] <String[]>
  [-AlwaysRequireAuthentication] [-Enabled <Boolean>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-Notes <String>] [-PassThru]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-ClaimsProviderName
  <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AlwaysRequireAuthentication Switch: ~
  -ClaimsProviderName String[]: ~
  -Enabled Boolean: ~
  -Identifier String[]:
    required: true
  -IssuanceAuthorizationRules String: ~
  -IssuanceAuthorizationRulesFile String: ~
  -Name String:
    required: true
  -Notes String: ~
  -PassThru Switch: ~
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
