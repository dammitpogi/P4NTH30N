description: Removes a binding from an IIS website
synopses:
- Remove-WebBinding [-Protocol <String>] [-Name <String>] [-IPAddress <String>] [-Port
  <String>] [-HostHeader <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-WebBinding -InputObject <PSObject> [-Protocol <String>] [-Name <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-WebBinding [-Protocol <String>] [-Name <String>] -BindingInformation <String>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BindingInformation String:
    required: true
  -Confirm,-cf Switch: ~
  -HostHeader String: ~
  -IPAddress String: ~
  -InputObject PSObject:
    required: true
  -Name String: ~
  -Port String: ~
  -Protocol String: ~
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
