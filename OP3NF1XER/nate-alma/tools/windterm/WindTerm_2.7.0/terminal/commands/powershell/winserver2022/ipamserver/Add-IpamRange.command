description: Adds an IP address range to the configuration of an IPAM server
synopses:
- Add-IpamRange [-CreateSubnetIfNotFound] [-NetworkId] <String> [[-StartIPAddress]
  <IPAddress>] [[-EndIPAddress] <IPAddress>] [-ManagedByService <String>] [-ServiceInstance
  <String>] [-NetworkType <VirtualizationType>] [-AddressSpace <String>] [-UtilizationCalculation
  <UtilizationCalculation>] [-UtilizedAddresses <Double>] [-Description <String>]
  [-Owner <String>] [-AssignmentType <AddressAssignment>] [-AssignmentDate <DateTime>]
  [-ReservedAddress <String[]>] [-DnsServer <IPAddress[]>] [-DnsSuffix <String[]>]
  [-ConnectionSpecificDnsSuffix <String>] [-WinsServer <IPAddress[]>] [-VIP <String[]>]
  [-Gateway <String[]>] [-CustomConfiguration <String>] [-AssociatedReverseLookupZone
  <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressSpace String: ~
  -AsJob Switch: ~
  -AssignmentDate DateTime: ~
  -AssignmentType AddressAssignment:
    values:
    - Static
    - Dynamic
    - Auto
    - VIP
    - Reserved
  -AssociatedReverseLookupZone String: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ConnectionSpecificDnsSuffix String: ~
  -CreateSubnetIfNotFound Switch: ~
  -CustomConfiguration String: ~
  -Description String: ~
  -DnsServer IPAddress[]: ~
  -DnsSuffix String[]: ~
  -EndIPAddress IPAddress: ~
  -Gateway String[]: ~
  -ManagedByService,-MB String: ~
  -NetworkId String:
    required: true
  -NetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -Owner String: ~
  -PassThru Switch: ~
  -ReservedAddress String[]: ~
  -ServiceInstance,-SI String: ~
  -StartIPAddress IPAddress: ~
  -ThrottleLimit Int32: ~
  -UtilizationCalculation UtilizationCalculation:
    values:
    - Auto
    - UserSpecified
  -UtilizedAddresses Double: ~
  -VIP String[]: ~
  -WhatIf,-wi Switch: ~
  -WinsServer IPAddress[]: ~
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
