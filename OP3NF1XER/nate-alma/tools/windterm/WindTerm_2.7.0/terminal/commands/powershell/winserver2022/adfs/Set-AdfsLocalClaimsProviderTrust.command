description: Modifies a local claims provider trust
synopses:
- Set-AdfsLocalClaimsProviderTrust [-AcceptanceTransformRules <String>] [-AcceptanceTransformRulesFile
  <String>] [-Name <String>] [-Notes <String>] [-OrganizationalAccountSuffix <String[]>]
  [-Force] -TargetClaimsProviderTrust <LocalClaimsProviderTrust> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsLocalClaimsProviderTrust [-AcceptanceTransformRules <String>] [-AcceptanceTransformRulesFile
  <String>] [-Name <String>] [-Notes <String>] [-OrganizationalAccountSuffix <String[]>]
  [-Force] -TargetIdentifier <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsLocalClaimsProviderTrust [-AcceptanceTransformRules <String>] [-AcceptanceTransformRulesFile
  <String>] [-Name <String>] [-Notes <String>] [-OrganizationalAccountSuffix <String[]>]
  [-Force] -TargetName <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptanceTransformRules String: ~
  -AcceptanceTransformRulesFile String: ~
  -Force Switch: ~
  -Name String: ~
  -Notes String: ~
  -OrganizationalAccountSuffix String[]: ~
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
