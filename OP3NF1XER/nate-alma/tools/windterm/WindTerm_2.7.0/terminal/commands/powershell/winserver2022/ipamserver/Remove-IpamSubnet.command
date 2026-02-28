description: Removes a subnet from IPAM
synopses:
- Remove-IpamSubnet -NetworkId <String[]> [-NetworkType <VirtualizationType[]>] [-AddressSpace
  <String[]>] [-DeleteAssociatedRanges] [-DeleteAssociatedAddresses] [-Force] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-IpamSubnet -InputObject <CimInstance[]> [-DeleteAssociatedRanges] [-DeleteAssociatedAddresses]
  [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressSpace String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DeleteAssociatedAddresses Switch: ~
  -DeleteAssociatedRanges Switch: ~
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -NetworkId String[]:
    required: true
  -NetworkType VirtualizationType[]:
    values:
    - NonVirtualized
    - Provider
    - Customer
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
