description: Removes a trusted federation partner in AD FS
synopses:
- Remove-AdfsTrustedFederationPartner [-TargetName] <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-AdfsTrustedFederationPartner [-TargetFederationPartnerHostName] <Uri> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AdfsTrustedFederationPartner [-TargetFederationPartner] <AdfsTrustedFederationPartner>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetFederationPartner AdfsTrustedFederationPartner:
    required: true
  -TargetFederationPartnerHostName Uri:
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
