description: Adds a relying party trust for the Web Application Proxy
synopses:
- Add-AdfsWebApplicationProxyRelyingPartyTrust [-Name] <String> [-Identifier] <String[]>
  [-AlwaysRequireAuthentication] [-Enabled <Boolean>] [-AccessControlPolicyName <String>]
  [-AccessControlPolicyParameters <Object>] [-AdditionalAuthenticationRules <String>]
  [-AdditionalAuthenticationRulesFile <String>] [-NotBeforeSkew <Int32>] [-Notes <String>]
  [-PassThru] [-TokenLifetime <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessControlPolicyName String: ~
  -AccessControlPolicyParameters Object: ~
  -AdditionalAuthenticationRules String: ~
  -AdditionalAuthenticationRulesFile String: ~
  -AlwaysRequireAuthentication Switch: ~
  -Enabled Boolean: ~
  -Identifier String[]:
    required: true
  -Name String:
    required: true
  -NotBeforeSkew Int32: ~
  -Notes String: ~
  -PassThru Switch: ~
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
