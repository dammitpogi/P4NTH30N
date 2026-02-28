description: Returns all child certificates from a parent certificate used in a user
  request for the AD RMS cluster
synopses:
- Get-RmsChildCert [-StartTime <DateTime>] [-EndTime <DateTime>] -ParentCertId <String>
  -ParentCertType <String> [-Path] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -EndTime DateTime: ~
  -ParentCertId String:
    required: true
  -ParentCertType String:
    required: true
    values:
    - CLC
    - Client-Licensor-Certificate
    - IL
    - Issuance-License
  -Path String[]:
    required: true
  -StartTime DateTime: ~
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
