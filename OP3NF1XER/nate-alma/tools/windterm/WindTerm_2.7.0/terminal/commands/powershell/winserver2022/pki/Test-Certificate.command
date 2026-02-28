description: Verifies a certificate according to the input parameters
synopses:
- Test-Certificate [-Policy <TestCertificatePolicy>] [-User] [-EKU <String[]>] [-DNSName
  <String>] [-AllowUntrustedRoot] [-Cert] <Certificate> [<CommonParameters>]
options:
  -AllowUntrustedRoot Switch: ~
  -Cert,-PsPath Certificate:
    required: true
  -DNSName String: ~
  -EKU String[]: ~
  -Policy TestCertificatePolicy:
    values:
    - BASE
    - SSL
    - AUTHENTICODE
    - NTAUTH
  -User Switch: ~
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
