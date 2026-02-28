description: Removes AIA or OCSP URI from the AIA extension set on the certification
  authority
synopses:
- Remove-CAAuthorityInformationAccess [-Uri] <String> [-AddToCertificateAia] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-CAAuthorityInformationAccess [-Uri] <String> [-AddToCertificateOcsp] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddToCertificateAia Switch: ~
  -AddToCertificateOcsp Switch: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
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
