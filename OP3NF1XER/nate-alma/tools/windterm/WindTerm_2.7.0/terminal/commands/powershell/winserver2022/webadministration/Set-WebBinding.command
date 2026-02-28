description: Changes a property of an IIS site binding
synopses:
- Set-WebBinding [[-Name] <String>] [[-IPAddress] <String>] [[-Port] <UInt32>] [-HostHeader
  <String>] -PropertyName <String> -Value <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-WebBinding [[-Name] <String>] [-BindingInformation] <String> -PropertyName <String>
  -Value <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BindingInformation String:
    required: true
  -Confirm,-cf Switch: ~
  -HostHeader String: ~
  -IPAddress String: ~
  -Name String: ~
  -Port UInt32: ~
  -PropertyName String:
    required: true
  -Value String:
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
