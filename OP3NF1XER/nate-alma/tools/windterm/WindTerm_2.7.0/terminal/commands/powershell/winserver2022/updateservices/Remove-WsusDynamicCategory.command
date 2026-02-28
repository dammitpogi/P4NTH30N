description: Removes a dynamic category from a WSUS server
synopses:
- powershell Remove-WsusDynamicCategory [-UpdateServer <IUpdateServer>] -InputObject
  <IDynamicCategory> [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Remove-WsusDynamicCategory [-UpdateServer <IUpdateServer>] -Name <String>
  -DynamicCategoryType <DynamicCategoryType> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DynamicCategoryType,-Type DynamicCategoryType:
    required: true
    values:
    - ComputerModel
    - Device
    - Application
    - Any
  -InputObject IDynamicCategory:
    required: true
  -Name String:
    required: true
  -UpdateServer IUpdateServer: ~
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
