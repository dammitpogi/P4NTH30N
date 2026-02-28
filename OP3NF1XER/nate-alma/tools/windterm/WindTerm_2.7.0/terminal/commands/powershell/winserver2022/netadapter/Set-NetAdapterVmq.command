description: Sets the VMQ properties of a network adapter
synopses:
- Set-NetAdapterVmq [-Name] <String[]> [-IncludeHidden] [-BaseProcessorGroup <UInt16>]
  [-BaseProcessorNumber <Byte>] [-MaxProcessors <UInt32>] [-MaxProcessorNumber <Byte>]
  [-NumaNode <UInt16>] [-Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterVmq -InterfaceDescription <String[]> [-IncludeHidden] [-BaseProcessorGroup
  <UInt16>] [-BaseProcessorNumber <Byte>] [-MaxProcessors <UInt32>] [-MaxProcessorNumber
  <Byte>] [-NumaNode <UInt16>] [-Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterVmq -InputObject <CimInstance[]> [-BaseProcessorGroup <UInt16>] [-BaseProcessorNumber
  <Byte>] [-MaxProcessors <UInt32>] [-MaxProcessorNumber <Byte>] [-NumaNode <UInt16>]
  [-Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BaseProcessorGroup,-BaseG UInt16: ~
  -BaseProcessorNumber,-BaseN Byte: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Enabled Boolean: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -MaxProcessorNumber,-MaxN Byte: ~
  -MaxProcessors,-Max UInt32: ~
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -NumaNode,-NumaN UInt16: ~
  -PassThru Switch: ~
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
