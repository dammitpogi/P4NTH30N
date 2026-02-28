description: Disables a claims provider trust in the Federation Service
synopses:
- Disable-AdfsClaimsProviderTrust -TargetClaimsProviderTrust <ClaimsProviderTrust>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsClaimsProviderTrust -TargetCertificate <X509Certificate2> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsClaimsProviderTrust -TargetIdentifier <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-AdfsClaimsProviderTrust -TargetName <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetCertificate X509Certificate2:
    required: true
  -TargetClaimsProviderTrust ClaimsProviderTrust:
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
