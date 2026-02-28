description: Removes an IIS configuration property
synopses:
- Remove-WebConfigurationProperty -Name <String> [-Clr <String>] [-AtElement <Hashtable>]
  [-AtIndex <Int32>] [-AtName <String>] [-Force] [-Location <String[]>] [-Filter]
  <String[]> [[-PSPath] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AtElement Hashtable: ~
  -AtIndex Int32: ~
  -AtName String: ~
  -Clr String: ~
  -Confirm,-cf Switch: ~
  -Filter String[]:
    required: true
  -Force Switch: ~
  -Location String[]: ~
  -Name String:
    required: true
  -PSPath String[]: ~
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
