description: Modifies an existing IP address range
synopses:
- Set-IpamRange [-StartIPAddress] <IPAddress[]> [-EndIPAddress] <IPAddress[]> [-ManagedByService
  <String[]>] [-ServiceInstance <String[]>] [-NetworkType <VirtualizationType[]>]
  [-AddressSpace <String[]>] [-CreateSubnetIfNotFound] [-NewNetworkId <String>] [-NewStartIPAddress
  <IPAddress>] [-NewEndIPAddress <IPAddress>] [-NewManagedByService <String>] [-NewServiceInstance
  <String>] [-NewNetworkType <VirtualizationType>] [-NewAddressSpace <String>] [-AssignmentType
  <AddressAssignment>] [-AssignmentDate <DateTime>] [-UtilizationCalculation <UtilizationCalculation>]
  [-UtilizedAddresses <Double>] [-Description <String>] [-Owner <String>] [-ReservedAddress
  <String[]>] [-DnsServer <IPAddress[]>] [-DnsSuffix <String[]>] [-ConnectionSpecificDnsSuffix
  <String>] [-WinsServer <IPAddress[]>] [-VIP <String[]>] [-Gateway <String[]>] [-AddCustomConfiguration
  <String>] [-RemoveCustomConfiguration <String>] [-AssociatedReverseLookupZone <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-IpamRange -InputObject <CimInstance[]> [-CreateSubnetIfNotFound] [-NewNetworkId
  <String>] [-NewStartIPAddress <IPAddress>] [-NewEndIPAddress <IPAddress>] [-NewManagedByService
  <String>] [-NewServiceInstance <String>] [-NewNetworkType <VirtualizationType>]
  [-NewAddressSpace <String>] [-AssignmentType <AddressAssignment>] [-AssignmentDate
  <DateTime>] [-UtilizationCalculation <UtilizationCalculation>] [-UtilizedAddresses
  <Double>] [-Description <String>] [-Owner <String>] [-ReservedAddress <String[]>]
  [-DnsServer <IPAddress[]>] [-DnsSuffix <String[]>] [-ConnectionSpecificDnsSuffix
  <String>] [-WinsServer <IPAddress[]>] [-VIP <String[]>] [-Gateway <String[]>] [-AddCustomConfiguration
  <String>] [-RemoveCustomConfiguration <String>] [-AssociatedReverseLookupZone <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AddCustomConfiguration String: ~
  -AddressSpace String[]: ~
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
  -Description String: ~
  -DnsServer IPAddress[]: ~
  -DnsSuffix String[]: ~
  -EndIPAddress IPAddress[]:
    required: true
  -Gateway String[]: ~
  -InputObject CimInstance[]:
    required: true
  -ManagedByService,-MB String[]: ~
  -NetworkType VirtualizationType[]:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -NewAddressSpace String: ~
  -NewEndIPAddress IPAddress: ~
  -NewManagedByService String: ~
  -NewNetworkId String: ~
  -NewNetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
  -NewServiceInstance String: ~
  -NewStartIPAddress IPAddress: ~
  -Owner String: ~
  -PassThru Switch: ~
  -RemoveCustomConfiguration String: ~
  -ReservedAddress String[]: ~
  -ServiceInstance,-SI String[]: ~
  -StartIPAddress IPAddress[]:
    required: true
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
