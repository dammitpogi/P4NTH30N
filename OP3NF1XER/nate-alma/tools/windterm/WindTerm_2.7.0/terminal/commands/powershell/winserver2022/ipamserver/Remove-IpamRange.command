description: Removes a range of IP addresses from an IPAM server configuration
synopses:
- Remove-IpamRange [-StartIPAddress] <IPAddress[]> [-EndIPAddress] <IPAddress[]> [-ManagedByService
  <String[]>] [-ServiceInstance <String[]>] [-NetworkType <VirtualizationType[]>]
  [-AddressSpace <String[]>] [-DeleteMappedAddresses] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-IpamRange -InputObject <CimInstance[]> [-DeleteMappedAddresses] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AddressSpace String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DeleteMappedAddresses Switch: ~
  -EndIPAddress IPAddress[]:
    required: true
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -ManagedByService,-MB String[]: ~
  -NetworkType VirtualizationType[]:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -PassThru Switch: ~
  -ServiceInstance,-SI String[]: ~
  -StartIPAddress IPAddress[]:
    required: true
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
