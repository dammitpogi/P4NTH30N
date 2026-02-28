description: Creates a network controller node object
synopses:
- New-NetworkControllerNodeObject -Name <String> -Server <String> -FaultDomain <String>
  -RestInterface <String> [-NodeCertificate <X509Certificate2>] [-NodeCertificateFindBy
  <X509FindType>] [-CertificateSubjectName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateSubjectName String: ~
  -Confirm,-cf Switch: ~
  -FaultDomain String:
    required: true
  -Name String:
    required: true
  -NodeCertificate X509Certificate2: ~
  -NodeCertificateFindBy X509FindType:
    values:
    - FindByThumbprint
    - FindBySubjectName
    - FindBySubjectDistinguishedName
    - FindByIssuerName
    - FindByIssuerDistinguishedName
    - FindBySerialNumber
    - FindByTimeValid
    - FindByTimeNotYetValid
    - FindByTimeExpired
    - FindByTemplateName
    - FindByApplicationPolicy
    - FindByCertificatePolicy
    - FindByExtension
    - FindByKeyUsage
    - FindBySubjectKeyIdentifier
  -RestInterface String:
    required: true
  -Server String:
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
