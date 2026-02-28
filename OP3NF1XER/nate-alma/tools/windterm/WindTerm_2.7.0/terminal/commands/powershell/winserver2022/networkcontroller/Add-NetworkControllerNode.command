description: Adds a network controller node to an existing network controller deployment
synopses:
- Add-NetworkControllerNode -Name <String> -Server <String> -FaultDomain <String>
  -RestInterface <String> [-NodeCertificate <X509Certificate2>] [-Force] [-PassThru]
  [-CertificateSubjectName <String>] [-NodeCertificateFindBy <X509FindType>] [-ComputerName
  <String>] [-UseSsl] [-Credential <PSCredential>] [-CertificateThumbprint <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateSubjectName String: ~
  -CertificateThumbprint String: ~
  -ComputerName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -FaultDomain String:
    required: true
  -Force Switch: ~
  -Name String:
    required: true
  -NodeCertificate X509Certificate2: ~
  -NodeCertificateFindBy X509FindType:
    values:
    - FindByThumbprint
    - FindBySubjectName
  -PassThru Switch: ~
  -RestInterface String:
    required: true
  -Server String:
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
