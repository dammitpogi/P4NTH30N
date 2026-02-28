description: Sets the properties of an existing certificate that AD FS uses to sign,
  decrypt, or secure communications
synopses:
- Set-AdfsCertificate -CertificateType <String> -Thumbprint <String> [-IsPrimary]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateType String:
    required: true
    values:
    - Service-Communications
    - Token-Decrypting
    - Token-Signing
  -IsPrimary Switch: ~
  -PassThru Switch: ~
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
