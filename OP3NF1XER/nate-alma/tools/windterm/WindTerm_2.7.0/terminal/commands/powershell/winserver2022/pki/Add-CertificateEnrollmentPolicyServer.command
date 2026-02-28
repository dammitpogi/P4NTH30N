description: Adds an enrollment policy server to the current user or local system
  configuration
synopses:
- Add-CertificateEnrollmentPolicyServer [-NoClobber] -Url <Uri> [-RequireStrongValidation]
  [-Credential <PkiCredential>] -context <Context> [-AutoEnrollmentEnabled] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AutoEnrollmentEnabled Switch: ~
  -Confirm,-cf Switch: ~
  -Credential PkiCredential: ~
  -NoClobber Switch: ~
  -RequireStrongValidation Switch: ~
  -Url Uri:
    required: true
  -WhatIf,-wi Switch: ~
  -context Context:
    required: true
    values:
    - Machine
    - User
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
