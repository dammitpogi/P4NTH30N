description: Installs the Device Health Attestation service
synopses:
- Install-DeviceHealthAttestation -EncryptionCertificateThumbprint <String> -SigningCertificateThumbprint
  <String> -SupportedAuthenticationSchema <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-DeviceHealthAttestation -EncryptionCertificateThumbprint <String> -SigningCertificateThumbprint
  <String> -SslCertificateThumbprint <String> [-SslCertificateStoreName <StoreName>]
  -SupportedAuthenticationSchema <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -EncryptionCertificateThumbprint String:
    required: true
  -Force Switch: ~
  -SigningCertificateThumbprint String:
    required: true
  -SslCertificateStoreName StoreName:
    values:
    - AddressBook
    - AuthRoot
    - CertificateAuthority
    - Disallowed
    - My
    - Root
    - TrustedPeople
    - TrustedPublisher
  -SslCertificateThumbprint String:
    required: true
  -SupportedAuthenticationSchema String:
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
