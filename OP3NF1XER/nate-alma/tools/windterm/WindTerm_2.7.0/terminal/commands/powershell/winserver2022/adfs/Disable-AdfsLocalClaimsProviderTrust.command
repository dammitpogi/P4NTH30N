description: Disables a local claims provider trust
synopses:
- Disable-AdfsLocalClaimsProviderTrust -TargetClaimsProviderTrust <LocalClaimsProviderTrust>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsLocalClaimsProviderTrust -TargetIdentifier <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-AdfsLocalClaimsProviderTrust -TargetName <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetClaimsProviderTrust LocalClaimsProviderTrust:
    required: true
  -TargetIdentifier String:
    required: true
  -TargetName String:
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
