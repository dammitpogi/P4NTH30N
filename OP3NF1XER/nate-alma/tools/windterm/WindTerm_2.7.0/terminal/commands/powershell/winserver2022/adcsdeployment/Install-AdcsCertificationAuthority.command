description: Performs installation and configuration of the AD CS Certification Authority
  role service
synopses:
- Install-AdcsCertificationAuthority [-AllowAdministratorInteraction] [-ValidityPeriod
  <ValidityPeriod>] [-ValidityPeriodUnits <Int32>] [-CACommonName <String>] [-CADistinguishedNameSuffix
  <String>] [-CAType <CAType>] [-CryptoProviderName <String>] [-DatabaseDirectory
  <String>] [-HashAlgorithmName <String>] [-IgnoreUnicode] [-KeyLength <Int32>] [-LogDirectory
  <String>] [-OutputCertRequestFile <String>] [-OverwriteExistingCAinDS] [-OverwriteExistingKey]
  [-ParentCA <String>] [-OverwriteExistingDatabase] [-Credential <PSCredential>] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-AdcsCertificationAuthority [-AllowAdministratorInteraction] [-CertFilePassword
  <SecureString>] [-CertFile <String>] [-CAType <CAType>] [-CertificateID <String>]
  [-DatabaseDirectory <String>] [-LogDirectory <String>] [-OverwriteExistingKey] [-OverwriteExistingDatabase]
  [-Credential <PSCredential>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-AdcsCertificationAuthority [-AllowAdministratorInteraction] [-ValidityPeriod
  <ValidityPeriod>] [-ValidityPeriodUnits <Int32>] [-CADistinguishedNameSuffix <String>]
  [-CAType <CAType>] [-CryptoProviderName <String>] [-DatabaseDirectory <String>]
  [-HashAlgorithmName <String>] [-IgnoreUnicode] [-KeyContainerName <String>] [-LogDirectory
  <String>] [-OutputCertRequestFile <String>] [-OverwriteExistingCAinDS] [-ParentCA
  <String>] [-OverwriteExistingDatabase] [-Credential <PSCredential>] [-Force] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllowAdministratorInteraction Switch: ~
  -CACommonName String: ~
  -CADistinguishedNameSuffix String: ~
  -CAType CAType:
    values:
    - EnterpriseRootCA
    - EnterpriseSubordinateCA
    - StandaloneRootCA
    - StandaloneSubordinateCA
  -CertFile String: ~
  -CertFilePassword SecureString: ~
  -CertificateID String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -CryptoProviderName String: ~
  -DatabaseDirectory String: ~
  -Force Switch: ~
  -HashAlgorithmName String: ~
  -IgnoreUnicode Switch: ~
  -KeyContainerName String: ~
  -KeyLength Int32: ~
  -LogDirectory String: ~
  -OutputCertRequestFile String: ~
  -OverwriteExistingCAinDS Switch: ~
  -OverwriteExistingDatabase Switch: ~
  -OverwriteExistingKey Switch: ~
  -ParentCA String: ~
  -ValidityPeriod ValidityPeriod:
    values:
    - Hours
    - Days
    - Weeks
    - Months
    - Years
  -ValidityPeriodUnits Int32: ~
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
