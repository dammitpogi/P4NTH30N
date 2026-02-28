description: Gets key certificates in the Key Protection Service
synopses:
- Get-HgsKeyProtectionCertificate [-CertificateType <KeyCertificateType>] [-IsEnabled
  <Boolean>] [-IsPrimary <Boolean>] [<CommonParameters>]
- Get-HgsKeyProtectionCertificate -CertificateType <KeyCertificateType> -Thumbprint
  <String> [<CommonParameters>]
options:
  -CertificateType KeyCertificateType:
    values:
    - Signing
    - Encryption
  -IsEnabled Boolean: ~
  -IsPrimary Boolean: ~
  -Thumbprint String:
    required: true
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
