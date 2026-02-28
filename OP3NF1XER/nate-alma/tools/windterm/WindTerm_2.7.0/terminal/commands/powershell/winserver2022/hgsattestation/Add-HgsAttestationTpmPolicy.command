description: Adds an attestation policy based on TPM 2.0 hardware to HGS
synopses:
- Add-HgsAttestationTpmPolicy [-InputObject] <Byte[]> -Name <String> [-PolicyVersion
  <PolicyVersion>] [-Stage] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-HgsAttestationTpmPolicy [-Path] <String> [-Name <String>] [-PolicyVersion <PolicyVersion>]
  [-Stage] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -InputObject Byte[]:
    required: true
  -Name String:
    required: true
  -Path,-FilePath,-PSPath String:
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
