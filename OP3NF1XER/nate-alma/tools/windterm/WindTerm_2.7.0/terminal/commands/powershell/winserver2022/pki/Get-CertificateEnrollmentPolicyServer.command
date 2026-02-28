description: Returns all of the certificate enrollment policy server URL configurations
synopses:
- Get-CertificateEnrollmentPolicyServer [-Url <Uri>] -Scope <EnrollmentPolicyServerScope>
  -context <Context> [<CommonParameters>]
options:
  -Scope EnrollmentPolicyServerScope:
    required: true
    values:
    - Applied
    - ConfiguredByYou
    - All
  -Url Uri: ~
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
