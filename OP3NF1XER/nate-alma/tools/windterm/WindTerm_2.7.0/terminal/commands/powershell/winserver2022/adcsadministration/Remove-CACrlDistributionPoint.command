description: Removes the URI for the CRL distribution point (CDP) from the CA
synopses:
- Remove-CACrlDistributionPoint [-Uri] <String> [-AddToCertificateCdp] [-AddToFreshestCrl]
  [-AddToCrlCdp] [-AddToCrlIdp] [-PublishToServer] [-PublishDeltaToServer] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddToCertificateCdp Switch: ~
  -AddToCrlCdp Switch: ~
  -AddToCrlIdp Switch: ~
  -AddToFreshestCrl Switch: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -PublishDeltaToServer Switch: ~
  -PublishToServer Switch: ~
  -Uri String:
    required: true
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
