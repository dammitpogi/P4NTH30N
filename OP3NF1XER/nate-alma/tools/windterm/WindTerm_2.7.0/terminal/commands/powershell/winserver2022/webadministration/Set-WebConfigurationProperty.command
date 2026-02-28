description: Changes the value of an IIS configuration property
synopses:
- Set-WebConfigurationProperty -Name <String> -Value <PSObject> [-Clr <String>] [-AtElement
  <Hashtable>] [-AtIndex <Int32>] [-AtName <String>] [-Force] [-Location <String[]>]
  [-Filter] <String[]> [[-PSPath] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-WebConfigurationProperty -Name <String> -InputObject <Object> [-Clr <String>]
  [-AtElement <Hashtable>] [-AtIndex <Int32>] [-AtName <String>] [-Force] [-Location
  <String[]>] [-Filter] <String[]> [[-PSPath] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AtElement Hashtable: ~
  -AtIndex Int32: ~
  -AtName String: ~
  -Clr String: ~
  -Confirm,-cf Switch: ~
  -Filter String[]:
    required: true
  -Force Switch: ~
  -InputObject Object:
    required: true
  -Location String[]: ~
  -Name String:
    required: true
  -PSPath String[]: ~
  -Value,-v,-val PSObject:
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
