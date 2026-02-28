description: Runs prerequisite checks for installing a new federation server farm
synopses:
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -FederationServiceName <String> [-FederationServiceDisplayName <String>] -ServiceAccountCredential
  <PSCredential> [-OverwriteConfiguration] [-SSLPort <Int32>] [-TlsClientPort <Int32>]
  [-AdminConfiguration <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -DecryptionCertificateThumbprint <String> -FederationServiceName <String> [-FederationServiceDisplayName
  <String>] -ServiceAccountCredential <PSCredential> -SigningCertificateThumbprint
  <String> [-OverwriteConfiguration] [-SSLPort <Int32>] [-TlsClientPort <Int32>] [-AdminConfiguration
  <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -DecryptionCertificateThumbprint <String> -FederationServiceName <String> [-FederationServiceDisplayName
  <String>] -ServiceAccountCredential <PSCredential> -SigningCertificateThumbprint
  <String> -SQLConnectionString <String> [-OverwriteConfiguration] [-SSLPort <Int32>]
  [-TlsClientPort <Int32>] [-AdminConfiguration <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -DecryptionCertificateThumbprint <String> -FederationServiceName <String> [-FederationServiceDisplayName
  <String>] -GroupServiceAccountIdentifier <String> -SigningCertificateThumbprint
  <String> [-OverwriteConfiguration] [-SSLPort <Int32>] [-TlsClientPort <Int32>] [-AdminConfiguration
  <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -DecryptionCertificateThumbprint <String> -FederationServiceName <String> [-FederationServiceDisplayName
  <String>] -GroupServiceAccountIdentifier <String> -SigningCertificateThumbprint
  <String> -SQLConnectionString <String> [-OverwriteConfiguration] [-SSLPort <Int32>]
  [-TlsClientPort <Int32>] [-AdminConfiguration <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -FederationServiceName <String> [-FederationServiceDisplayName <String>] -ServiceAccountCredential
  <PSCredential> -SQLConnectionString <String> [-OverwriteConfiguration] [-SSLPort
  <Int32>] [-TlsClientPort <Int32>] [-AdminConfiguration <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -FederationServiceName <String> [-FederationServiceDisplayName <String>] -GroupServiceAccountIdentifier
  <String> [-OverwriteConfiguration] [-SSLPort <Int32>] [-TlsClientPort <Int32>] [-AdminConfiguration
  <Hashtable>] [<CommonParameters>]
- Test-AdfsFarmInstallation [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  -FederationServiceName <String> [-FederationServiceDisplayName <String>] -GroupServiceAccountIdentifier
  <String> -SQLConnectionString <String> [-OverwriteConfiguration] [-SSLPort <Int32>]
  [-TlsClientPort <Int32>] [-AdminConfiguration <Hashtable>] [<CommonParameters>]
options:
  -AdminConfiguration Hashtable: ~
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -DecryptionCertificateThumbprint String:
    required: true
  -FederationServiceDisplayName String: ~
  -FederationServiceName String:
    required: true
  -GroupServiceAccountIdentifier String:
    required: true
  -OverwriteConfiguration Switch: ~
  -ServiceAccountCredential PSCredential:
    required: true
  -SigningCertificateThumbprint String:
    required: true
  -SQLConnectionString String:
    required: true
  -SSLPort Int32: ~
  -TlsClientPort Int32: ~
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
