description: Imports IP address into the IPAM server
synopses:
- Import-IpamAddress -Path <String> -AddressFamily <AddressFamily> [-ErrorPath <String>]
  [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Import-IpamAddress -Path <String> -AddressFamily <AddressFamily> [-ErrorPath <String>]
  [-Force] -ManagedByService <String> -ServiceInstance <String> -NetworkId <String>
  [-StartIpAddress <IPAddress>] [-EndIpAddress <IPAddress>] [-NetworkType <VirtualizationType>]
  [-AddressSpace <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily:
    required: true
    values:
    - IPv4
    - IPv6
  -AddressSpace String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EndIpAddress IPAddress: ~
  -ErrorPath String: ~
  -Force Switch: ~
  -ManagedByService,-MB String:
    required: true
  -NetworkId String:
    required: true
  -NetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -Path String:
    required: true
  -ServiceInstance,-SI String:
    required: true
  -StartIpAddress IPAddress: ~
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
