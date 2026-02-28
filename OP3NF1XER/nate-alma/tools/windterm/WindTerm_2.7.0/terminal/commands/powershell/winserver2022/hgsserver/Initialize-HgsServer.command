description: Initializes the Host Guardian Service server
synopses:
- Initialize-HgsServer [-HgsServiceName] <String> [-UseHgsDomain] [-LogDirectory <String>]
  [-Http] [-Https] [-HttpPort <UInt16>] [-HttpsPort <UInt16>] [-HttpsCertificatePath
  <String>] [-HttpsCertificatePassword <SecureString>] [-HttpsCertificateThumbprint
  <String>] [-TrustActiveDirectory] [-TrustTpm] [-EncryptionCertificateThumbprint
  <String>] [-EncryptionCertificatePath <String>] [-EncryptionCertificatePassword
  <SecureString>] [-SigningCertificateThumbprint <String>] [-SigningCertificatePath
  <String>] [-SigningCertificatePassword <SecureString>] [-HgsVersion <HgsVersion>]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Initialize-HgsServer [-HgsServiceName] <String> [-UseExistingDomain] [-LogDirectory
  <String>] -JeaAdministratorsGroup <ADGroup> -JeaReviewersGroup <ADGroup> -ServiceAccount
  <ADServiceAccount> [-ClusterName <String>] [-Http] [-Https] [-HttpPort <UInt16>]
  [-HttpsPort <UInt16>] [-HttpsCertificatePath <String>] [-HttpsCertificatePassword
  <SecureString>] [-HttpsCertificateThumbprint <String>] [-TrustActiveDirectory] [-TrustTpm]
  [-EncryptionCertificateThumbprint <String>] [-EncryptionCertificatePath <String>]
  [-EncryptionCertificatePassword <SecureString>] [-SigningCertificateThumbprint <String>]
  [-SigningCertificatePath <String>] [-SigningCertificatePassword <SecureString>]
  [-HgsVersion <HgsVersion>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Initialize-HgsServer [-HgsServerIPAddress] <String> [-LogDirectory <String>] [-Http]
  [-Https] [-HttpPort <UInt16>] [-HttpsPort <UInt16>] [-HttpsCertificatePath <String>]
  [-HttpsCertificatePassword <SecureString>] [-HttpsCertificateThumbprint <String>]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ClusterName String: ~
  -EncryptionCertificatePassword SecureString: ~
  -EncryptionCertificatePath String: ~
  -EncryptionCertificateThumbprint String: ~
  -Force Switch: ~
  -HgsServerIPAddress String:
    required: true
  -HgsServiceName String:
    required: true
  -HgsVersion HgsVersion:
    values:
    - HgsVersion1503
    - HgsVersion1704
  -Http Switch: ~
  -HttpPort UInt16: ~
  -Https Switch: ~
  -HttpsCertificatePassword SecureString: ~
  -HttpsCertificatePath String: ~
  -HttpsCertificateThumbprint String: ~
  -HttpsPort UInt16: ~
  -JeaAdministratorsGroup ADGroup:
    required: true
  -JeaReviewersGroup ADGroup:
    required: true
  -LogDirectory String: ~
  -ServiceAccount ADServiceAccount:
    required: true
  -SigningCertificatePassword SecureString: ~
  -SigningCertificatePath String: ~
  -SigningCertificateThumbprint String: ~
  -TrustActiveDirectory Switch: ~
  -TrustTpm Switch: ~
  -UseExistingDomain Switch:
    required: true
  -UseHgsDomain Switch: ~
  -Confirm,-cf Switch: ~
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
