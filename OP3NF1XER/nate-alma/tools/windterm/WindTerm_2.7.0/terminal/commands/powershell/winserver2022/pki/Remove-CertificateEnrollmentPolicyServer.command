description: Removes an enrollment policy server and the URL of the enrollment policy
  server from the current user or local computer configuration
synopses:
- Remove-CertificateEnrollmentPolicyServer [-Url] <Uri> -context <Context> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
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
