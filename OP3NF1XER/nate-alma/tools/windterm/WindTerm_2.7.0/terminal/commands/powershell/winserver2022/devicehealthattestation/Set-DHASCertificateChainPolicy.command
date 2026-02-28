description: Sets certificate chain policy
synopses:
- Set-DHASCertificateChainPolicy [-CertificateChainPolicy] <CertificateChainPolicy>
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DHASCertificateChainPolicy -RevocationFlag <String> -RevocationMode <String>
  -VerificationFlags <String> -UrlRetrievalTimeout <String> [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CertificateChainPolicy CertificateChainPolicy:
    required: true
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -RevocationFlag String:
    required: true
  -RevocationMode String:
    required: true
  -UrlRetrievalTimeout String:
    required: true
  -VerificationFlags String:
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
