description: Removes a guarded host with TPM 2.0 from the Attestation service in HGS
synopses:
- Remove-HgsAttestationTpmHost [-Name] <String> [-PolicyVersion <PolicyVersion>] [-Stage]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Name String:
    required: true
  -PolicyVersion PolicyVersion:
    values:
    - None
    - PolicyVersion1503
    - PolicyVersion1704
  -Stage Switch: ~
  -Confirm,-cf Switch: ~
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
