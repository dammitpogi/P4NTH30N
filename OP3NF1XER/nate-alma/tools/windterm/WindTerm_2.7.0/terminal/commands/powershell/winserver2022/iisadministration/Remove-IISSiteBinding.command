description: Removes a binding from an IIS website. This cmdlet has been introduced
  in version 1.1.0.0 of IISAdministration module
synopses:
- Remove-IISSiteBinding [-Name] <String> [-BindingInformation] <String> [[-Protocol]
  <String>] [-RemoveConfigOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BindingInformation String:
    required: true
  -Name String:
    required: true
  -Protocol String: ~
  -RemoveConfigOnly Switch: ~
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
