description: Sets the global rules that provide the trigger for additional authentication
  providers to be invoked
synopses:
- Set-AdfsAdditionalAuthenticationRule [-AdditionalAuthenticationRules] <String> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsAdditionalAuthenticationRule [-AdditionalAuthenticationRulesFile] <String>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AdditionalAuthenticationRules String:
    required: true
  -AdditionalAuthenticationRulesFile String:
    required: true
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
