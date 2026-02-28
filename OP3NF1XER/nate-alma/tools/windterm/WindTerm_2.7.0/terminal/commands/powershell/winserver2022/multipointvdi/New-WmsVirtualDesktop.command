description: Creates a virtual desktop
synopses:
- New-WmsVirtualDesktop [-StationId] <UInt32[]> -InputFilePath <String> [-VhdLocation
  <String>] -TemplatePrefix <String> [-Domain <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-WmsVirtualDesktop [-All] -InputFilePath <String> [-VhdLocation <String>] -TemplatePrefix
  <String> [-Domain <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -Confirm,-cf Switch: ~
  -Domain String: ~
  -InputFilePath String:
    required: true
  -StationId UInt32[]:
    required: true
  -TemplatePrefix String:
    required: true
  -VhdLocation String: ~
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
