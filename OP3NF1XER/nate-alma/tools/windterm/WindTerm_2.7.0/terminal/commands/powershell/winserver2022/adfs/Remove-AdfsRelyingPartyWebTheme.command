description: Removes a web theme to a relying party
synopses:
- Remove-AdfsRelyingPartyWebTheme [-TargetRelyingPartyName] <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsRelyingPartyWebTheme [-TargetRelyingPartyWebTheme] <AdfsRelyingPartyWebTheme>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -TargetRelyingPartyName,-Name String:
    required: true
  -TargetRelyingPartyWebTheme,-TargetWebTheme AdfsRelyingPartyWebTheme:
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
