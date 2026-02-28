description: Creates an IIS Website
synopses:
- New-IISSite [-Name] <String> [-PhysicalPath] <String> [-BindingInformation] <String>
  [[-Protocol] <String>] [[-CertificateThumbPrint] <String>] [[-SslFlag] <SslFlags>]
  [[-CertStoreLocation] <String>] [-Force] [-Passthru] [<CommonParameters>]
options:
  -BindingInformation String:
    required: true
  -CertificateThumbPrint String: ~
  -CertStoreLocation String: ~
  -Force Switch: ~
  -Name String:
    required: true
  -Passthru Switch: ~
  -PhysicalPath String:
    required: true
  -Protocol String: ~
  -SslFlag SslFlags:
    values:
    - None
    - Sni
    - CentralCertStore
    - DisableHTTP2
    - DisableOCSPStp
    - DisableQUIC
    - DisableTLS13
    - DisableLegacyTLS
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
