description: Adds an IP address to IPAM
synopses:
- Add-IpamAddress [-IpAddress] <IPAddress> [[-ManagedByService] <String>] [[-ServiceInstance]
  <String>] [-NetworkType <VirtualizationType>] [-AddressSpace <String>] [-DeviceType
  <String>] [-IpAddressState <String>] [-AssignmentType <AddressAssignment>] [-MacAddress
  <String>] [-AssignmentDate <DateTime>] [-ExpiryDate <DateTime>] [-Description <String>]
  [-Owner <String>] [-AssetTag <String>] [-SerialNumber <String>] [-ClientId <String>]
  [-Duid <String>] [-Iaid <UInt32>] [-ReservationServer <String>] [-ReservationName
  <String>] [-ReservationType <DhcpReservationType>] [-ReservationDescription <String>]
  [-DeviceName <String>] [-ForwardLookupZone <String>] [-ForwardLookupPrimaryServer
  <String>] [-ReverseLookupZone <String>] [-ReverseLookupPrimaryServer <String>] [-CustomConfiguration
  <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressSpace String: ~
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
  -CustomConfiguration String: ~
  -Description String: ~
  -DeviceName String: ~
  -DeviceType String: ~
  -Duid String: ~
  -ExpiryDate DateTime: ~
  -ForwardLookupPrimaryServer String: ~
  -ForwardLookupZone,-FwdLookupZone String: ~
  -Iaid UInt32: ~
  -IpAddress IPAddress:
    required: true
  -IpAddressState String: ~
  -MacAddress String: ~
  -ManagedByService,-MB String: ~
  -NetworkType VirtualizationType:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -Owner String: ~
  -PassThru Switch: ~
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
  -ReverseLookupZone,-RevLookupZone String: ~
  -SerialNumber,-SN String: ~
  -ServiceInstance,-SI String: ~
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
