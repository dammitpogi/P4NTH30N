description: Adds an attestation policy for an Active Directory host group configuration
synopses:
- Add-HgsAttestationHostGroup -Name <String> -HostGroup <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-HgsAttestationHostGroup -Name <String> -Identifier <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -HostGroup String:
    required: true
  -Identifier String:
    required: true
  -Name String:
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
