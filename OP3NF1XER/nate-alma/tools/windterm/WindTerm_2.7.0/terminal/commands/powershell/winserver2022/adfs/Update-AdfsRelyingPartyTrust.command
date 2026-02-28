description: Updates the relying party trust from federation metadata
synopses:
- Update-AdfsRelyingPartyTrust [-MetadataFile <String>] -TargetIdentifier <String>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-AdfsRelyingPartyTrust [-MetadataFile <String>] -TargetRelyingParty <RelyingPartyTrust>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-AdfsRelyingPartyTrust [-MetadataFile <String>] -TargetName <String> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -MetadataFile String: ~
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
