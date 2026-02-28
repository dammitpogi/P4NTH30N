description: Creates a Host Guardian Service guardian
synopses:
- New-HgsGuardian [-Name] <String> -SigningCertificate <String> [-SigningCertificatePassword
  <SecureString>] -EncryptionCertificate <String> [-EncryptionCertificatePassword
  <SecureString>] [-AllowExpired] [-AllowUntrustedRoot] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-HgsGuardian [-Name] <String> [-AllowExpired] [-AllowUntrustedRoot] -SigningCertificateThumbprint
  <String> -EncryptionCertificateThumbprint <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- New-HgsGuardian [-Name] <String> [-GenerateCertificates] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowExpired Switch: ~
  -AllowUntrustedRoot Switch: ~
  -EncryptionCertificate String:
    required: true
  -EncryptionCertificatePassword SecureString: ~
  -EncryptionCertificateThumbprint String:
    required: true
  -GenerateCertificates Switch:
    required: true
  -Name String:
    required: true
  -SigningCertificate String:
    required: true
  -SigningCertificatePassword SecureString: ~
  -SigningCertificateThumbprint String:
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
