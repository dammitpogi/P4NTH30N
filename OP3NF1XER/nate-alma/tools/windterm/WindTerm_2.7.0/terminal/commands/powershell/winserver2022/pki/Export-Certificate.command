description: Exports a certificate from a certificate store into a file
synopses:
- Export-Certificate [-Type <CertType>] [-NoClobber] [-Force] -FilePath <String> -Cert
  <Certificate> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Cert Certificate:
    required: true
  -Confirm,-cf Switch: ~
  -FilePath,-FullName String:
    required: true
  -Force Switch: ~
  -NoClobber Switch: ~
  -Type CertType:
    values:
    - SST
    - CERT
    - P7B
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
