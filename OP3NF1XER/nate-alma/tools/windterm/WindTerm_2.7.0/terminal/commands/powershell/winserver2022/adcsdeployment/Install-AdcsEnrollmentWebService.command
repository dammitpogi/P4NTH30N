description: Performs the initial configuration of the Certificate Enrollment Web
  service
synopses:
- Install-AdcsEnrollmentWebService [-CAConfig <String>] [-ApplicationPoolIdentity]
  [-AuthenticationType <AuthenticationType>] [-SSLCertThumbprint <String>] [-RenewalOnly]
  [-AllowKeyBasedRenewal] [-Force] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Install-AdcsEnrollmentWebService [-CAConfig <String>] -ServiceAccountName <String>
  -ServiceAccountPassword <SecureString> [-AuthenticationType <AuthenticationType>]
  [-SSLCertThumbprint <String>] [-RenewalOnly] [-AllowKeyBasedRenewal] [-Force] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowKeyBasedRenewal Switch: ~
  -ApplicationPoolIdentity Switch: ~
  -AuthenticationType AuthenticationType:
    values:
    - Kerberos
    - UserName
    - Certificate
  -CAConfig String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -RenewalOnly Switch: ~
  -SSLCertThumbprint String: ~
  -ServiceAccountName String:
    required: true
  -ServiceAccountPassword SecureString:
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
