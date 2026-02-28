description: Creates a relying party trusts group
synopses:
- Add-AdfsRelyingPartyTrustsGroup -MetadataFile <String> [-Force] [-PassThru] [-MonitoringEnabled
  <Boolean>] [-ImpersonationAuthorizationRules <String>] [-ImpersonationAuthorizationRulesFile
  <String>] [-IssuanceTransformRules <String>] [-IssuanceTransformRulesFile <String>]
  [-IssuanceAuthorizationRules <String>] [-IssuanceAuthorizationRulesFile <String>]
  [-DelegationAuthorizationRules <String>] [-DelegationAuthorizationRulesFile <String>]
  [-AdditionalAuthenticationRules <String>] [-AdditionalAuthenticationRulesFile <String>]
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-AdfsRelyingPartyTrustsGroup -MetadataUrl <Uri> [-AutoUpdateEnabled <Boolean>]
  [-Force] [-PassThru] [-MonitoringEnabled <Boolean>] [-ImpersonationAuthorizationRules
  <String>] [-ImpersonationAuthorizationRulesFile <String>] [-IssuanceTransformRules
  <String>] [-IssuanceTransformRulesFile <String>] [-IssuanceAuthorizationRules <String>]
  [-IssuanceAuthorizationRulesFile <String>] [-DelegationAuthorizationRules <String>]
  [-DelegationAuthorizationRulesFile <String>] [-AdditionalAuthenticationRules <String>]
  [-AdditionalAuthenticationRulesFile <String>] [-AccessControlPolicyName <String>]
  [-AccessControlPolicyParameters <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AutoUpdateEnabled Boolean: ~
  -DelegationAuthorizationRules String: ~
  -DelegationAuthorizationRulesFile String: ~
  -Force Switch: ~
  -ImpersonationAuthorizationRules String: ~
  -ImpersonationAuthorizationRulesFile String: ~
  -IssuanceAuthorizationRules String: ~
  -IssuanceAuthorizationRulesFile String: ~
  -IssuanceTransformRules String: ~
  -IssuanceTransformRulesFile String: ~
  -MetadataFile String:
    required: true
  -MetadataUrl Uri:
    required: true
  -MonitoringEnabled Boolean: ~
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
