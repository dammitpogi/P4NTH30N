description: Creates a Network Controller cluster
synopses:
- Install-NetworkControllerCluster -Node <NetworkControllerNode[]> -ClusterAuthentication
  <ClusterAuthentication> [-ManagementSecurityGroup <String>] [-DiagnosticLogLocation
  <String>] [-LogLocationCredential <PSCredential>] [-CredentialEncryptionCertificate
  <X509Certificate2>] [-GmsaAccountName <String>] [-LogTimeLimitInDays <UInt32>] [-LogSizeLimitInMBs
  <UInt32>] [-EnableAutomaticUpdates <Boolean>] [-Force] [-UseSsl] [-Credential <PSCredential>]
  [-CertificateThumbprint <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ClusterAuthentication ClusterAuthentication:
    required: true
    values:
    - None
    - Kerberos
    - X509
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -CredentialEncryptionCertificate X509Certificate2: ~
  -DiagnosticLogLocation String: ~
  -EnableAutomaticUpdates Boolean: ~
  -Force Switch: ~
  -GmsaAccountName String: ~
  -LogLocationCredential PSCredential: ~
  -LogSizeLimitInMBs UInt32: ~
  -LogTimeLimitInDays UInt32: ~
  -ManagementSecurityGroup String: ~
  -Node NetworkControllerNode[]:
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
