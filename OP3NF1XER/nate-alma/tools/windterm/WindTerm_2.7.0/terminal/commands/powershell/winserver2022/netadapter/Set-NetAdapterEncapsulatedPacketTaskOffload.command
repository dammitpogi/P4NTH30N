description: Sets the encapsulated packet task offload property of the network adapter
synopses:
- Set-NetAdapterEncapsulatedPacketTaskOffload [-Name] <String[]> [-IncludeHidden]
  [-NvgreEncapsulatedPacketTaskOffloadEnabled <Boolean>] [-VxlanEncapsulatedPacketTaskOffloadEnabled
  <Boolean>] [-VxlanUDPPortNumber <UInt16>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterEncapsulatedPacketTaskOffload -InterfaceDescription <String[]> [-IncludeHidden]
  [-NvgreEncapsulatedPacketTaskOffloadEnabled <Boolean>] [-VxlanEncapsulatedPacketTaskOffloadEnabled
  <Boolean>] [-VxlanUDPPortNumber <UInt16>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterEncapsulatedPacketTaskOffload -InputObject <CimInstance[]> [-NvgreEncapsulatedPacketTaskOffloadEnabled
  <Boolean>] [-VxlanEncapsulatedPacketTaskOffloadEnabled <Boolean>] [-VxlanUDPPortNumber
  <UInt16>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -NvgreEncapsulatedPacketTaskOffloadEnabled Boolean: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -VxlanEncapsulatedPacketTaskOffloadEnabled Boolean: ~
  -VxlanUDPPortNumber UInt16: ~
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
