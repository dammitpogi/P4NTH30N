description: Sets the USO properties of a network adapter
synopses:
- Set-NetAdapterUso [-Name] <String[]> [-IncludeHidden] [-IPv4Enabled <Boolean>] [-IPv6Enabled
  <Boolean>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterUso -InterfaceDescription <String[]> [-IncludeHidden] [-IPv4Enabled
  <Boolean>] [-IPv6Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterUso -InputObject <CimInstance[]> [-IPv4Enabled <Boolean>] [-IPv6Enabled
  <Boolean>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -IPv4Enabled Boolean: ~
  -IPv6Enabled Boolean: ~
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
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
