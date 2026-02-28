description: Uninstalls the Certificate Enrollment Web service or individual instances
  of it
synopses:
- Uninstall-AdcsEnrollmentWebService -CAConfig <String> -AuthenticationType <AuthenticationType>
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Uninstall-AdcsEnrollmentWebService [-AllEnrollmentServices] [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AllEnrollmentServices Switch: ~
  -AuthenticationType AuthenticationType:
    required: true
    values:
    - Kerberos
    - UserName
    - Certificate
  -CAConfig String:
    required: true
  -Confirm,-cf Switch: ~
  -Force Switch: ~
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
