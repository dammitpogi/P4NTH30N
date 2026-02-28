description: Creates a new virtual switch on one or more virtual machine hosts
synopses:
- New-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-AllowManagementOS <Boolean>] -NetAdapterName
  <String[]> [-Notes <String>] [-MinimumBandwidthMode <VMSwitchBandwidthMode>] [-EnableIov
  <Boolean>] [-EnablePacketDirect <Boolean>] [-EnableEmbeddedTeaming <Boolean>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> [-AllowManagementOS <Boolean>] -NetAdapterInterfaceDescription
  <String[]> [-Notes <String>] [-MinimumBandwidthMode <VMSwitchBandwidthMode>] [-EnableIov
  <Boolean>] [-EnablePacketDirect <Boolean>] [-EnableEmbeddedTeaming <Boolean>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-VMSwitch [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String> -SwitchType <VMSwitchType> [-Notes <String>]
  [-MinimumBandwidthMode <VMSwitchBandwidthMode>] [-EnableIov <Boolean>] [-EnablePacketDirect
  <Boolean>] [-EnableEmbeddedTeaming <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowManagementOS Boolean: ~
  -CimSession CimSession[]: ~
  -ComputerName,-PSComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -EnableEmbeddedTeaming Boolean: ~
  -EnableIov Boolean: ~
  -EnablePacketDirect Boolean: ~
  -MinimumBandwidthMode VMSwitchBandwidthMode:
    values:
    - Default
    - Weight
    - Absolute
    - None
  -Name,-SwitchName String:
    required: true
  -NetAdapterInterfaceDescription,-InterfaceDescription String[]:
    required: true
  -NetAdapterName,-InterfaceAlias String[]:
    required: true
  -Notes String: ~
  -SwitchType VMSwitchType:
    required: true
    values:
    - Internal
    - Private
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
