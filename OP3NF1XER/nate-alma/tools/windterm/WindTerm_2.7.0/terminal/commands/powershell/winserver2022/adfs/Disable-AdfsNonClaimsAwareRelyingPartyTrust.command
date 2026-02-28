description: Disables a relying party trust for a non-claims-aware web application
  or service from the Federation Service
synopses:
- Disable-AdfsNonClaimsAwareRelyingPartyTrust [-PassThru] [-TargetName] <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-AdfsNonClaimsAwareRelyingPartyTrust [-PassThru] -TargetIdentifier <String>
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsNonClaimsAwareRelyingPartyTrust [-PassThru] -TargetNonClaimsAwareRelyingPartyTrust
  <NonClaimsAwareRelyingPartyTrust> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
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
