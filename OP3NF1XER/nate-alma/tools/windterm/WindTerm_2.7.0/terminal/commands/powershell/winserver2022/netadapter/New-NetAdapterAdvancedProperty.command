description: Creates an advanced property for the network adapter
synopses:
- New-NetAdapterAdvancedProperty -RegistryKeyword <String> [-RegistryDataType <RegDataType>]
  -RegistryValue <String[]> [-NoRestart] [-IncludeHidden] [-Name] <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-NetAdapterAdvancedProperty -InterfaceDescription <String> -RegistryKeyword <String>
  [-RegistryDataType <RegDataType>] -RegistryValue <String[]> [-NoRestart] [-IncludeHidden]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IncludeHidden Switch: ~
  -InterfaceDescription,-ifDesc,-InstanceID String:
    required: true
  -Name,-ifAlias,-InterfaceAlias String:
    required: true
  -NoRestart Switch: ~
  -RegistryDataType RegDataType:
    values:
    - None
    - REG_SZ
    - REG_DWORD
    - REG_MULTI_SZ
    - REG_QWORD
  -RegistryKeyword String:
    required: true
  -RegistryValue String[]:
    required: true
  -ThrottleLimit Int32: ~
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
