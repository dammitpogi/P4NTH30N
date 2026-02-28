description: Adds a subnet to IPAM
synopses:
- Add-IpamSubnet [-Name] <String> [-NetworkId] <String> [-NetworkType <VirtualizationType>]
  [-AddressSpace <String>] [-Owner <String>] [-Description <String>] [-VlanId <UInt16[]>]
  [-VmmLogicalNetwork <String>] [-NetworkSite <String>] [-VirtualSubnetId <UInt32>]
  [-CustomConfiguration <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressSpace String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CustomConfiguration String: ~
  -Description String: ~
  -Name String:
    required: true
  -NetworkId String:
    required: true
  -NetworkSite String: ~
  -NetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -Owner String: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -VirtualSubnetId UInt32: ~
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
