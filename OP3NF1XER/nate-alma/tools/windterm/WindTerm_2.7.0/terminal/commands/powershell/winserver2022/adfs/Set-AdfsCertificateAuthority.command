description: Modifies a certificate authority
synopses:
- Set-AdfsCertificateAuthority [-SelfIssued] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsCertificateAuthority [-RolloverSigningCertificate] [-ForcePromotion] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsCertificateAuthority [-EnrollmentAgent] [-CertificateAuthority <String>]
  [-LogonCertificateTemplate <String>] [-WindowsHelloCertificateTemplate <String>]
  [-EnrollmentAgentCertificateTemplate <String>] [-AutoEnrollEnabled <Boolean>] [-CertificateGenerationThresholdDays
  <Int32>] [-WindowsHelloCertificateProxyEnabled <Boolean>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AutoEnrollEnabled Boolean: ~
  -CertificateAuthority String: ~
  -CertificateGenerationThresholdDays Int32: ~
  -EnrollmentAgent Switch:
    required: true
  -EnrollmentAgentCertificateTemplate String: ~
  -ForcePromotion Switch: ~
  -LogonCertificateTemplate String: ~
  -PassThru Switch: ~
  -RolloverSigningCertificate Switch:
    required: true
  -SelfIssued Switch:
    required: true
  -WindowsHelloCertificateProxyEnabled Boolean: ~
  -WindowsHelloCertificateTemplate String: ~
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
