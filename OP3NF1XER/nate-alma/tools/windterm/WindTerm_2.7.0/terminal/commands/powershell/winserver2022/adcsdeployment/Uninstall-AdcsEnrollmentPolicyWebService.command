description: Uninstalls the Certificate Enrollment Policy Web service
synopses:
- Uninstall-AdcsEnrollmentPolicyWebService -AuthenticationType <AuthenticationType>
  [-KeyBasedRenewal] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Uninstall-AdcsEnrollmentPolicyWebService [-AllPolicyServers] [-Force] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllPolicyServers Switch: ~
  -AuthenticationType AuthenticationType:
    required: true
    values:
    - Kerberos
    - UserName
    - Certificate
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -KeyBasedRenewal Switch: ~
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
