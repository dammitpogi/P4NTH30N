description: Disables a relying party trust of the Federation Service
synopses:
- Disable-AdfsRelyingPartyTrust -TargetIdentifier <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-AdfsRelyingPartyTrust -TargetRelyingParty <RelyingPartyTrust> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsRelyingPartyTrust -TargetName <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
  -TargetRelyingParty RelyingPartyTrust:
    required: true
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
