description: Creates a certificate for an RDS role
synopses:
- New-RDCertificate [-Role] <RDCertificateRole> -DnsName <String> [-ExportPath <String>]
  -Password <SecureString> [-ConnectionBroker <String>] [-Force] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -DnsName String:
    required: true
  -ExportPath String: ~
  -Force Switch: ~
  -Password SecureString:
    required: true
  -Role RDCertificateRole:
    required: true
    values:
    - RDGateway
    - RDWebAccess
    - RDRedirector
    - RDPublishing
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
