description: Configures features of the virtual network adapter in a virtual machine
  or the management operating system
synopses:
- Set-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-Name <String>] [-DynamicMacAddress] [-StaticMacAddress
  <String>] [-MacAddressSpoofing <OnOffState>] [-DhcpGuard <OnOffState>] [-RouterGuard
  <OnOffState>] [-PortMirroring <VMNetworkAdapterPortMirroringMode>] [-IeeePriorityTag
  <OnOffState>] [-VmqWeight <UInt32>] [-IovQueuePairsRequested <UInt32>] [-IovInterruptModeration
  <IovInterruptModerationValue>] [-IovWeight <UInt32>] [-IPsecOffloadMaximumSecurityAssociation
  <UInt32>] [-MaximumBandwidth <Int64>] [-MinimumBandwidthAbsolute <Int64>] [-MinimumBandwidthWeight
  <UInt32>] [-MandatoryFeatureId <String[]>] [-ResourcePoolName <String>] [-TestReplicaPoolName
  <String>] [-TestReplicaSwitchName <String>] [-VirtualSubnetId <UInt32>] [-AllowTeaming
  <OnOffState>] [-NotMonitoredInCluster <Boolean>] [-StormLimit <UInt32>] [-DynamicIPAddressLimit
  <UInt32>] [-DeviceNaming <OnOffState>] [-FixSpeed10G <OnOffState>] [-PacketDirectNumProcs
  <UInt32>] [-PacketDirectModerationCount <UInt32>] [-PacketDirectModerationInterval
  <UInt32>] [-VrssEnabled <Boolean>] [-VmmqEnabled <Boolean>] [-VmmqQueuePairs <UInt32>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapter [-ManagementOS] [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-Name <String>] [-MacAddressSpoofing
  <OnOffState>] [-DhcpGuard <OnOffState>] [-RouterGuard <OnOffState>] [-PortMirroring
  <VMNetworkAdapterPortMirroringMode>] [-IeeePriorityTag <OnOffState>] [-VmqWeight
  <UInt32>] [-IovQueuePairsRequested <UInt32>] [-IovInterruptModeration <IovInterruptModerationValue>]
  [-IovWeight <UInt32>] [-IPsecOffloadMaximumSecurityAssociation <UInt32>] [-MaximumBandwidth
  <Int64>] [-MinimumBandwidthAbsolute <Int64>] [-MinimumBandwidthWeight <UInt32>]
  [-MandatoryFeatureId <String[]>] [-ResourcePoolName <String>] [-TestReplicaPoolName
  <String>] [-TestReplicaSwitchName <String>] [-VirtualSubnetId <UInt32>] [-AllowTeaming
  <OnOffState>] [-NotMonitoredInCluster <Boolean>] [-StormLimit <UInt32>] [-DynamicIPAddressLimit
  <UInt32>] [-DeviceNaming <OnOffState>] [-FixSpeed10G <OnOffState>] [-PacketDirectNumProcs
  <UInt32>] [-PacketDirectModerationCount <UInt32>] [-PacketDirectModerationInterval
  <UInt32>] [-VrssEnabled <Boolean>] [-VmmqEnabled <Boolean>] [-VmmqQueuePairs <UInt32>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapterBase> [-DynamicMacAddress]
  [-StaticMacAddress <String>] [-MacAddressSpoofing <OnOffState>] [-DhcpGuard <OnOffState>]
  [-RouterGuard <OnOffState>] [-PortMirroring <VMNetworkAdapterPortMirroringMode>]
  [-IeeePriorityTag <OnOffState>] [-VmqWeight <UInt32>] [-IovQueuePairsRequested <UInt32>]
  [-IovInterruptModeration <IovInterruptModerationValue>] [-IovWeight <UInt32>] [-IPsecOffloadMaximumSecurityAssociation
  <UInt32>] [-MaximumBandwidth <Int64>] [-MinimumBandwidthAbsolute <Int64>] [-MinimumBandwidthWeight
  <UInt32>] [-MandatoryFeatureId <String[]>] [-ResourcePoolName <String>] [-TestReplicaPoolName
  <String>] [-TestReplicaSwitchName <String>] [-VirtualSubnetId <UInt32>] [-AllowTeaming
  <OnOffState>] [-NotMonitoredInCluster <Boolean>] [-StormLimit <UInt32>] [-DynamicIPAddressLimit
  <UInt32>] [-DeviceNaming <OnOffState>] [-FixSpeed10G <OnOffState>] [-PacketDirectNumProcs
  <UInt32>] [-PacketDirectModerationCount <UInt32>] [-PacketDirectModerationInterval
  <UInt32>] [-VrssEnabled <Boolean>] [-VmmqEnabled <Boolean>] [-VmmqQueuePairs <UInt32>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapter [-VM] <VirtualMachine> [-Name <String>] [-DynamicMacAddress]
  [-StaticMacAddress <String>] [-MacAddressSpoofing <OnOffState>] [-DhcpGuard <OnOffState>]
  [-RouterGuard <OnOffState>] [-PortMirroring <VMNetworkAdapterPortMirroringMode>]
  [-IeeePriorityTag <OnOffState>] [-VmqWeight <UInt32>] [-IovQueuePairsRequested <UInt32>]
  [-IovInterruptModeration <IovInterruptModerationValue>] [-IovWeight <UInt32>] [-IPsecOffloadMaximumSecurityAssociation
  <UInt32>] [-MaximumBandwidth <Int64>] [-MinimumBandwidthAbsolute <Int64>] [-MinimumBandwidthWeight
  <UInt32>] [-MandatoryFeatureId <String[]>] [-ResourcePoolName <String>] [-TestReplicaPoolName
  <String>] [-TestReplicaSwitchName <String>] [-VirtualSubnetId <UInt32>] [-AllowTeaming
  <OnOffState>] [-NotMonitoredInCluster <Boolean>] [-StormLimit <UInt32>] [-DynamicIPAddressLimit
  <UInt32>] [-DeviceNaming <OnOffState>] [-FixSpeed10G <OnOffState>] [-PacketDirectNumProcs
  <UInt32>] [-PacketDirectModerationCount <UInt32>] [-PacketDirectModerationInterval
  <UInt32>] [-VrssEnabled <Boolean>] [-VmmqEnabled <Boolean>] [-VmmqQueuePairs <UInt32>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowTeaming OnOffState:
    values:
    - On
    - Off
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DeviceNaming OnOffState:
    values:
    - On
    - Off
  -DhcpGuard OnOffState:
    values:
    - On
    - Off
  -DynamicIPAddressLimit UInt32: ~
  -DynamicMacAddress Switch: ~
  -FixSpeed10G OnOffState:
    values:
    - On
    - Off
  -IPsecOffloadMaximumSecurityAssociation UInt32: ~
  -IeeePriorityTag OnOffState:
    values:
    - On
    - Off
  -IovInterruptModeration IovInterruptModerationValue:
    values:
    - Default
    - Adaptive
    - Off
    - Low
    - Medium
    - High
  -IovQueuePairsRequested UInt32: ~
  -IovWeight UInt32: ~
  -MacAddressSpoofing OnOffState:
    values:
    - On
    - Off
  -ManagementOS Switch:
    required: true
  -MandatoryFeatureId String[]: ~
  -MaximumBandwidth Int64: ~
  -MinimumBandwidthAbsolute Int64: ~
  -MinimumBandwidthWeight UInt32: ~
  -Name,-VMNetworkAdapterName String: ~
  -NotMonitoredInCluster Boolean: ~
  -PacketDirectModerationCount UInt32: ~
  -PacketDirectModerationInterval UInt32: ~
  -PacketDirectNumProcs UInt32: ~
  -Passthru Switch: ~
  -PortMirroring VMNetworkAdapterPortMirroringMode:
    values:
    - None
    - Destination
    - Source
  -ResourcePoolName String: ~
  -RouterGuard OnOffState:
    values:
    - On
    - Off
  -StaticMacAddress String: ~
  -StormLimit UInt32: ~
  -TestReplicaPoolName String: ~
  -TestReplicaSwitchName String: ~
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase:
    required: true
  -VirtualSubnetId UInt32: ~
  -VmmqEnabled Boolean: ~
  -VmmqQueuePairs UInt32: ~
  -VmqWeight UInt32: ~
  -VrssEnabled Boolean: ~
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
