description: Submits a certificate request to an enrollment server and installs the
  response or retrieves a certificate for a previously submitted request
synopses:
- Get-Certificate [-Url <Uri>] -Template <String> [-SubjectName <String>] [-DnsName
  <String[]>] [-Credential <PkiCredential>] [-CertStoreLocation <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Get-Certificate -Request <Certificate> [-Credential <PkiCredential>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CertStoreLocation String: ~
  -Confirm,-cf Switch: ~
  -Credential PkiCredential: ~
  -DnsName String[]: ~
  -Request Certificate:
    required: true
  -SubjectName String: ~
  -Template String:
    required: true
  -Url Uri: ~
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
