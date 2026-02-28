description: Creates a network controller application on top of the network controller
  cluster
synopses:
- Install-NetworkController -Node <NetworkControllerNode[]> -ClientAuthentication
  <ClientAuthentication> [-ClientCertificateThumbprint <String[]>] [-ClientSecurityGroup
  <String>] -ServerCertificate <X509Certificate2> [-RestIPAddress <String>] [-RestName
  <String>] [-Force] [-ComputerName <String>] [-UseSsl] [-Credential <PSCredential>]
  [-CertificateThumbprint <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ClientAuthentication ClientAuthentication:
    required: true
    values:
    - None
    - Kerberos
    - X509
  -ClientCertificateThumbprint String[]: ~
  -ClientSecurityGroup String: ~
  -ComputerName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -Node NetworkControllerNode[]:
    required: true
  -RestIPAddress String: ~
  -RestName String: ~
  -ServerCertificate X509Certificate2:
    required: true
  -UseSsl Switch: ~
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
