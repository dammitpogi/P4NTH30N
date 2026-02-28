description: Sets the advanced properties of a network adapter
synopses:
- Set-NetAdapterAdvancedProperty [[-Name] <String[]>] [-DisplayName <String[]>] [-RegistryKeyword
  <String[]>] [-IncludeHidden] [-AllProperties] [-DisplayValue <String>] [-RegistryValue
  <String[]>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterAdvancedProperty -InterfaceDescription <String[]> [-DisplayName <String[]>]
  [-RegistryKeyword <String[]>] [-IncludeHidden] [-AllProperties] [-DisplayValue <String>]
  [-RegistryValue <String[]>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterAdvancedProperty -InputObject <CimInstance[]> [-DisplayValue <String>]
  [-RegistryValue <String[]>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllProperties Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DisplayName,-DispN String[]: ~
  -DisplayValue String: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
  -NoRestart Switch: ~
  -PassThru Switch: ~
  -RegistryKeyword,-RegKey String[]: ~
  -RegistryValue String[]: ~
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
