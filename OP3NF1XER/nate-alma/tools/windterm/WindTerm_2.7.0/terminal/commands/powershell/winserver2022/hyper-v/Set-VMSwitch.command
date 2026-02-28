description: Configures a virtual switch
synopses:
- Set-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-SwitchType <VMSwitchType>] [-AllowManagementOS
  <Boolean>] [-DefaultFlowMinimumBandwidthAbsolute <Int64>] [-DefaultFlowMinimumBandwidthWeight
  <Int64>] [-DefaultQueueVrssEnabled <Boolean>] [-DefaultQueueVmmqEnabled <Boolean>]
  [-DefaultQueueVmmqQueuePairs <UInt32>] [-Extensions <VMSwitchExtension[]>] [-Notes
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMSwitch] <VMSwitch[]> [-SwitchType <VMSwitchType>] [-AllowManagementOS
  <Boolean>] [-DefaultFlowMinimumBandwidthAbsolute <Int64>] [-DefaultFlowMinimumBandwidthWeight
  <Int64>] [-DefaultQueueVrssEnabled <Boolean>] [-DefaultQueueVmmqEnabled <Boolean>]
  [-DefaultQueueVmmqQueuePairs <UInt32>] [-Extensions <VMSwitchExtension[]>] [-Notes
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-NetAdapterInterfaceDescription] <String>
  [-AllowManagementOS <Boolean>] [-DefaultFlowMinimumBandwidthAbsolute <Int64>] [-DefaultFlowMinimumBandwidthWeight
  <Int64>] [-DefaultQueueVrssEnabled <Boolean>] [-DefaultQueueVmmqEnabled <Boolean>]
  [-DefaultQueueVmmqQueuePairs <UInt32>] [-Extensions <VMSwitchExtension[]>] [-Notes
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-NetAdapterName] <String> [-AllowManagementOS
  <Boolean>] [-DefaultFlowMinimumBandwidthAbsolute <Int64>] [-DefaultFlowMinimumBandwidthWeight
  <Int64>] [-DefaultQueueVrssEnabled <Boolean>] [-DefaultQueueVmmqEnabled <Boolean>]
  [-DefaultQueueVmmqQueuePairs <UInt32>] [-Extensions <VMSwitchExtension[]>] [-Notes
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMSwitch] <VMSwitch[]> [-NetAdapterInterfaceDescription] <String>
  [-AllowManagementOS <Boolean>] [-DefaultFlowMinimumBandwidthAbsolute <Int64>] [-DefaultFlowMinimumBandwidthWeight
  <Int64>] [-DefaultQueueVrssEnabled <Boolean>] [-DefaultQueueVmmqEnabled <Boolean>]
  [-DefaultQueueVmmqQueuePairs <UInt32>] [-Extensions <VMSwitchExtension[]>] [-Notes
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMSwitch] <VMSwitch[]> [-NetAdapterName] <String> [-AllowManagementOS
  <Boolean>] [-DefaultFlowMinimumBandwidthAbsolute <Int64>] [-DefaultFlowMinimumBandwidthWeight
  <Int64>] [-DefaultQueueVrssEnabled <Boolean>] [-DefaultQueueVmmqEnabled <Boolean>]
  [-DefaultQueueVmmqQueuePairs <UInt32>] [-Extensions <VMSwitchExtension[]>] [-Notes
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowManagementOS Boolean: ~
  -CimSession CimSession[]: ~
  -ComputerName,-PSComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DefaultFlowMinimumBandwidthAbsolute Int64: ~
  -DefaultFlowMinimumBandwidthWeight Int64: ~
  -DefaultQueueVmmqEnabled Boolean: ~
  -DefaultQueueVmmqQueuePairs UInt32: ~
  -DefaultQueueVrssEnabled Boolean: ~
  -Extensions VMSwitchExtension[]: ~
  -Name,-SwitchName String[]:
    required: true
  -NetAdapterInterfaceDescription String:
    required: true
  -NetAdapterName,-InterfaceAlias String:
    required: true
  -Notes String: ~
  -Passthru Switch: ~
  -SwitchType VMSwitchType:
    values:
    - Private
    - Internal
    - External
  -VMSwitch VMSwitch[]:
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
