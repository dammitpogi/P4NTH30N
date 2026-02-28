description: Gets dynamic categories on a WSUS server
synopses:
- powershell Get-WsusDynamicCategory [-UpdateServer <IUpdateServer>] [-DynamicCategoryTypeFilter
  <DynamicCategoryType>] [-First <Int64>] [-Skip <Int64>] [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Get-WsusDynamicCategory [-UpdateServer <IUpdateServer>] -DynamicCategoryType
  <DynamicCategoryType> -Name <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DynamicCategoryType,-Type DynamicCategoryType:
    required: true
    values:
    - ComputerModel
    - Device
    - Application
    - Any
  -DynamicCategoryTypeFilter,-TypeFilter DynamicCategoryType:
    values:
    - ComputerModel
    - Device
    - Application
    - Any
  -First Int64: ~
  -Name String:
    required: true
  -Skip Int64: ~
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
