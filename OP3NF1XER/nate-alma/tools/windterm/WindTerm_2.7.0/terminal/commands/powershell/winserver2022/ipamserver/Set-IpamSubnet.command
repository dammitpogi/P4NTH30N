description: Modifies an existing IP subnet in IPAM
synopses:
- Set-IpamSubnet -NetworkId <String[]> [-NetworkType <VirtualizationType[]>] [-AddressSpace
  <String[]>] [-NewNetworkId <String>] [-NewNetworkType <VirtualizationType>] [-NewAddressSpace
  <String>] [-Name <String>] [-Owner <String>] [-Description <String>] [-VlanId <UInt16[]>]
  [-VmmLogicalNetwork <String>] [-NetworkSite <String>] [-VirtualSubnetId <Int32>]
  [-AddCustomConfiguration <String>] [-RemoveCustomConfiguration <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-IpamSubnet -InputObject <CimInstance[]> [-NewNetworkId <String>] [-NewNetworkType
  <VirtualizationType>] [-NewAddressSpace <String>] [-Name <String>] [-Owner <String>]
  [-Description <String>] [-VlanId <UInt16[]>] [-VmmLogicalNetwork <String>] [-NetworkSite
  <String>] [-VirtualSubnetId <Int32>] [-AddCustomConfiguration <String>] [-RemoveCustomConfiguration
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddCustomConfiguration String: ~
  -AddressSpace String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -InputObject CimInstance[]:
    required: true
  -Name String: ~
  -NetworkId String[]:
    required: true
  -NetworkSite String: ~
  -NetworkType VirtualizationType[]:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -NewAddressSpace String: ~
  -NewNetworkId String: ~
  -NewNetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
  -Owner String: ~
  -PassThru Switch: ~
  -RemoveCustomConfiguration String: ~
  -ThrottleLimit Int32: ~
  -VirtualSubnetId Int32: ~
  -VlanId UInt16[]: ~
  -VmmLogicalNetwork String: ~
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
