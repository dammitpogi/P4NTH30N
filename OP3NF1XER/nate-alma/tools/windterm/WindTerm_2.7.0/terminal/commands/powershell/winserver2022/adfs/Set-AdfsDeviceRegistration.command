description: Configures the administrative policies for the Device Registration Service
synopses:
- Set-AdfsDeviceRegistration -MaximumInactiveDays <UInt32> [-AccessControlPolicyName
  <String>] [-AccessControlPolicyParameters <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsDeviceRegistration -DevicesPerUser <UInt32> [-AccessControlPolicyName <String>]
  [-AccessControlPolicyParameters <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsDeviceRegistration -ServiceAccountIdentifier <String> -Credential <PSCredential>
  [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters <Object>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsDeviceRegistration [-IssuanceCertificate] [-AccessControlPolicyName <String>]
  [-AccessControlPolicyParameters <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsDeviceRegistration [-AccessControlPolicyName <String>] [-AccessControlPolicyParameters
  <Object>] [-AllowedAuthenticationClassReferences <String[]>] [-IssuanceAuthorizationRules
  <String>] [-IssuanceAuthorizationRulesFile <String>] [-IssuanceTransformRules <String>]
  [-IssuanceTransformRulesFile <String>] [-AdditionalAuthenticationRules <String>]
  [-AdditionalAuthenticationRulesFile <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AllowedAuthenticationClassReferences String[]: ~
  -Credential PSCredential:
    required: true
  -DevicesPerUser UInt32:
    required: true
  -IssuanceAuthorizationRules String: ~
  -IssuanceAuthorizationRulesFile String: ~
  -IssuanceCertificate Switch:
    required: true
  -IssuanceTransformRules String: ~
  -IssuanceTransformRulesFile String: ~
  -MaximumInactiveDays UInt32:
    required: true
  -ServiceAccountIdentifier String:
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
