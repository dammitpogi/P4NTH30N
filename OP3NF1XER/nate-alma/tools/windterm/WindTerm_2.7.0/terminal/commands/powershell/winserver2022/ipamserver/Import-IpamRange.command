description: Imports one or more IP address range objects from the specified file
  into the IPAM server
synopses:
- Import-IpamRange -Path <String> -AddressFamily <AddressFamily> [-ErrorPath <String>]
  [-CreateSubnetIfNotFound] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-IpamRange -Path <String> -AddressFamily <AddressFamily> [-ErrorPath <String>]
  [-CreateSubnetIfNotFound] [-Force] -ManagedByService <String> -ServiceInstance <String>
  [-AddManagedByService] [-AddServiceInstance] [-DeleteMappedAddresses] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddManagedByService Switch: ~
  -AddServiceInstance Switch: ~
  -AddressFamily AddressFamily:
    required: true
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CreateSubnetIfNotFound Switch: ~
  -DeleteMappedAddresses Switch: ~
  -ErrorPath String: ~
  -Force Switch: ~
  -ManagedByService,-MB String:
    required: true
  -Path String:
    required: true
  -ServiceInstance,-SI String:
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
