description: Configures the AIA or OCSP for a certification authority
synopses:
- Add-CAAuthorityInformationAccess [-InputObject] <AuthorityInformationAccess> [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-CAAuthorityInformationAccess [-Uri] <String> [-AddToCertificateOcsp] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-CAAuthorityInformationAccess [-Uri] <String> [-AddToCertificateAia] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddToCertificateAia Switch:
    required: true
  -AddToCertificateOcsp Switch:
    required: true
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject AuthorityInformationAccess:
    required: true
  -Uri String:
    required: true
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
