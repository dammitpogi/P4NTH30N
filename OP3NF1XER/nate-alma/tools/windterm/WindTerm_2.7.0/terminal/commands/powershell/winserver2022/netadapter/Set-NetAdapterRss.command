description: Sets the RSS properties on a network adapter
synopses:
- Set-NetAdapterRss [-Name] <String[]> [-IncludeHidden] [-NumberOfReceiveQueues <UInt32>]
  [-Profile <Profile>] [-BaseProcessorGroup <UInt16>] [-BaseProcessorNumber <Byte>]
  [-MaxProcessorGroup <UInt16>] [-MaxProcessorNumber <Byte>] [-MaxProcessors <UInt32>]
  [-NumaNode <UInt16>] [-Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterRss -InterfaceDescription <String[]> [-IncludeHidden] [-NumberOfReceiveQueues
  <UInt32>] [-Profile <Profile>] [-BaseProcessorGroup <UInt16>] [-BaseProcessorNumber
  <Byte>] [-MaxProcessorGroup <UInt16>] [-MaxProcessorNumber <Byte>] [-MaxProcessors
  <UInt32>] [-NumaNode <UInt16>] [-Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterRss -InputObject <CimInstance[]> [-NumberOfReceiveQueues <UInt32>]
  [-Profile <Profile>] [-BaseProcessorGroup <UInt16>] [-BaseProcessorNumber <Byte>]
  [-MaxProcessorGroup <UInt16>] [-MaxProcessorNumber <Byte>] [-MaxProcessors <UInt32>]
  [-NumaNode <UInt16>] [-Enabled <Boolean>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -MaxProcessorGroup,-MaxG UInt16: ~
  -MaxProcessorNumber,-MaxN Byte: ~
  -MaxProcessors,-Max UInt32: ~
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -NumaNode UInt16: ~
  -NumberOfReceiveQueues UInt32: ~
  -PassThru Switch: ~
  -Profile Profile:
    values:
    - Closest
    - ClosestStatic
    - NUMA
    - NUMAStatic
    - Conservative
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
