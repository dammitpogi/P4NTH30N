description: Imports or applies a certificate to use with an RDS role
synopses:
- PowerShell Set-RDCertificate [-Role] <RDCertificateRole> [-Password <SecureString>]
  [-ConnectionBroker <String>] [-Force] [<CommonParameters>]
- PowerShell Set-RDCertificate [-Role] <RDCertificateRole> [-ImportPath <String>]
  [-Password <SecureString>] [-ConnectionBroker <String>] [-Force] [<CommonParameters>]
- PowerShell Set-RDCertificate [-Role] <RDCertificateRole> [-Thumbprint <String>]
  [-ConnectionBroker <String>] [-Force] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -Force Switch: ~
  -ImportPath String: ~
  -Password SecureString: ~
  -Role RDCertificateRole:
    required: true
    values:
    - RDGateway
    - RDWebAccess
    - RDRedirector
    - RDPublishing
  -Thumbprint String: ~
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
