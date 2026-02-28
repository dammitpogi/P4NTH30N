description: Modifies an IP address in IPAM
synopses:
- Set-IpamAddress [-IpAddress] <IPAddress[]> [[-ManagedByService] <String[]>] [[-ServiceInstance]
  <String[]>] [-NetworkType <VirtualizationType[]>] [-AddressSpace <String[]>] [-NewIPAddress
  <IPAddress>] [-NewManagedByService <String>] [-NewServiceInstance <String>] [-NewNetworkType
  <VirtualizationType>] [-NewAddressSpace <String>] [-DeviceType <String>] [-IpAddressState
  <String>] [-AssignmentType <AddressAssignment>] [-AssignmentDate <DateTime>] [-MacAddress
  <String>] [-ExpiryDate <DateTime>] [-Description <String>] [-Owner <String>] [-AssetTag
  <String>] [-SerialNumber <String>] [-ClientId <String>] [-Duid <String>] [-Iaid
  <UInt32>] [-ReservationServer <String>] [-ReservationName <String>] [-ReservationType
  <DhcpReservationType>] [-ReservationDescription <String>] [-DeviceName <String>]
  [-ForwardLookupZone <String>] [-ForwardLookupPrimaryServer <String>] [-ReverseLookupZone
  <String>] [-ReverseLookupPrimaryServer <String>] [-AddCustomConfiguration <String>]
  [-RemoveCustomConfiguration <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAddress -InputObject <CimInstance[]> [-NewIPAddress <IPAddress>] [-NewManagedByService
  <String>] [-NewServiceInstance <String>] [-NewNetworkType <VirtualizationType>]
  [-NewAddressSpace <String>] [-DeviceType <String>] [-IpAddressState <String>] [-AssignmentType
  <AddressAssignment>] [-AssignmentDate <DateTime>] [-MacAddress <String>] [-ExpiryDate
  <DateTime>] [-Description <String>] [-Owner <String>] [-AssetTag <String>] [-SerialNumber
  <String>] [-ClientId <String>] [-Duid <String>] [-Iaid <UInt32>] [-ReservationServer
  <String>] [-ReservationName <String>] [-ReservationType <DhcpReservationType>] [-ReservationDescription
  <String>] [-DeviceName <String>] [-ForwardLookupZone <String>] [-ForwardLookupPrimaryServer
  <String>] [-ReverseLookupZone <String>] [-ReverseLookupPrimaryServer <String>] [-AddCustomConfiguration
  <String>] [-RemoveCustomConfiguration <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddCustomConfiguration String: ~
  -AddressSpace String[]: ~
  -AsJob Switch: ~
  -AssetTag String: ~
  -AssignmentDate DateTime: ~
  -AssignmentType AddressAssignment:
    values:
    - Static
    - Dynamic
    - Auto
    - VIP
    - Reserved
  -CimSession,-Session CimSession[]: ~
  -ClientId String: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DeviceName String: ~
  -DeviceType String: ~
  -Duid String: ~
  -ExpiryDate DateTime: ~
  -ForwardLookupPrimaryServer String: ~
  -ForwardLookupZone String: ~
  -Iaid UInt32: ~
  -InputObject CimInstance[]:
    required: true
  -IpAddress IPAddress[]:
    required: true
  -IpAddressState String: ~
  -MacAddress String: ~
  -ManagedByService,-MB String[]: ~
  -NetworkType VirtualizationType[]:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -NewAddressSpace String: ~
  -NewIPAddress IPAddress: ~
  -NewManagedByService String: ~
  -NewNetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
  -NewServiceInstance String: ~
  -Owner String: ~
  -PassThru Switch: ~
  -RemoveCustomConfiguration String: ~
  -ReservationDescription String: ~
  -ReservationName String: ~
  -ReservationServer String: ~
  -ReservationType DhcpReservationType:
    values:
    - None
    - Dhcp
    - Bootp
    - Both
  -ReverseLookupPrimaryServer String: ~
  -ReverseLookupZone String: ~
  -SerialNumber String: ~
  -ServiceInstance,-SI String[]: ~
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
