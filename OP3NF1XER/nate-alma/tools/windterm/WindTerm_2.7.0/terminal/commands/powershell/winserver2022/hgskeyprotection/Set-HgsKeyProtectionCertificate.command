description: Modifies properties of a key certificate in the Key Protection Service
synopses:
- Set-HgsKeyProtectionCertificate -CertificateType <KeyCertificateType> -Thumbprint
  <String> [-IsEnabled <Boolean>] [-IsPrimary] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateType KeyCertificateType:
    required: true
    values:
    - Signing
    - Encryption
  -Force Switch: ~
  -IsEnabled Boolean: ~
  -IsPrimary Switch: ~
  -Thumbprint String:
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
