description: Performs the configuration of Certificate Enrollment Policy Web service
synopses:
- Install-AdcsEnrollmentPolicyWebService [-AuthenticationType <AuthenticationType>]
  [-SSLCertThumbprint <String>] [-KeyBasedRenewal] [-Force] [-Credential <PSCredential>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AuthenticationType AuthenticationType:
    values:
    - Kerberos
    - UserName
    - Certificate
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -KeyBasedRenewal Switch: ~
  -SSLCertThumbprint String: ~
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
