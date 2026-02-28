description: Retrieves certificate auto-enrollment policy settings
synopses:
- Get-CertificateAutoEnrollmentPolicy -Scope <AutoEnrollmentPolicyScope> -context
  <Context> [<CommonParameters>]
options:
  -Scope AutoEnrollmentPolicyScope:
    required: true
    values:
    - Applied
    - Local
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
