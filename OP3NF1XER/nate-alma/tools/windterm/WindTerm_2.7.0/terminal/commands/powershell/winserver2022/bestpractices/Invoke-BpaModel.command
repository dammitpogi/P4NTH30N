description: Starts a BPA scan for a specific model that is installed on a computer
synopses:
- Invoke-BpaModel [-ModelId] <String> [-RepositoryPath <String>] [-Mode <ScanMode>]
  [<CommonParameters>]
- Invoke-BpaModel [-ModelId] <String> [-RepositoryPath <String>] [-Mode <ScanMode>]
  [-SubModelId <String>] [-Context <String>] [-ComputerName <String[]>] [-CertificateThumbprint
  <String>] [-ConfigurationName <String>] [-Credential <PSCredential>] [-Authentication
  <AuthenticationMechanism>] [-Port <Int32>] [-ThrottleLimit <Int32>] [-UseSsl] [<CommonParameters>]
options:
  -Authentication AuthenticationMechanism:
    values:
    - Default
    - Basic
    - Negotiate
    - NegotiateWithImplicitCredential
    - Credssp
    - Digest
    - Kerberos
  -CertificateThumbprint String: ~
  -ComputerName String[]: ~
  -ConfigurationName String: ~
  -Context String: ~
  -Credential PSCredential: ~
  -Mode ScanMode:
    values:
    - All
    - Discovery
    - Analysis
  -ModelId,-Id,-BestPracticesModelId String:
    required: true
  -Port Int32: ~
  -RepositoryPath String: ~
  -SubModelId String: ~
  -ThrottleLimit Int32: ~
  -UseSsl Switch: ~
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
