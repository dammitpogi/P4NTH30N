description: Installs the NDES role service
synopses:
- Install-AdcsNetworkDeviceEnrollmentService [-ApplicationPoolIdentity] [-RAName <String>]
  [-RAEmail <String>] [-RACompany <String>] [-RADepartment <String>] [-RACity <String>]
  [-RAState <String>] [-RACountry <String>] [-SigningProviderName <String>] [-SigningKeyLength
  <Int32>] [-EncryptionProviderName <String>] [-EncryptionKeyLength <Int32>] [-CAConfig
  <String>] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-AdcsNetworkDeviceEnrollmentService -ServiceAccountName <String> -ServiceAccountPassword
  <SecureString> [-RAName <String>] [-RAEmail <String>] [-RACompany <String>] [-RADepartment
  <String>] [-RACity <String>] [-RAState <String>] [-RACountry <String>] [-SigningProviderName
  <String>] [-SigningKeyLength <Int32>] [-EncryptionProviderName <String>] [-EncryptionKeyLength
  <Int32>] [-CAConfig <String>] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -ApplicationPoolIdentity Switch: ~
  -CAConfig String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -EncryptionKeyLength Int32: ~
  -EncryptionProviderName String: ~
  -Force Switch: ~
  -RACity String: ~
  -RACompany String: ~
  -RACountry String: ~
  -RADepartment String: ~
  -RAEmail String: ~
  -RAName String: ~
  -RAState String: ~
  -ServiceAccountName String:
    required: true
  -ServiceAccountPassword SecureString:
    required: true
  -SigningKeyLength Int32: ~
  -SigningProviderName String: ~
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
