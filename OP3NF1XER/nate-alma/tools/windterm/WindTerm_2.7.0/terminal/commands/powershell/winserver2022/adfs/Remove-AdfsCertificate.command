description: Removes a certificate from AD FS
synopses:
- Remove-AdfsCertificate [-TargetCertificate] <ServiceCertificate> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsCertificate -CertificateType <String> -Thumbprint <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CertificateType String:
    required: true
    values:
    - Token-Decrypting
    - Token-Signing
  -TargetCertificate ServiceCertificate:
    required: true
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
