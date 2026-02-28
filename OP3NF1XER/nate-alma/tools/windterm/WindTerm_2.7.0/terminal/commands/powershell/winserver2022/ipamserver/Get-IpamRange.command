description: Gets a set of IP address ranges from an IPAM server
synopses:
- Get-IpamRange -StartIPAddress <IPAddress[]> -EndIPAddress <IPAddress[]> [-ManagedByService
  <String[]>] [-ServiceInstance <String[]>] [-NetworkType <VirtualizationType[]>]
  [-AddressSpace <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-IpamRange -AddressFamily <AddressFamily[]> [-AddressCategory <AddressCategory[]>]
  [-ManagedByService <String[]>] [-ServiceInstance <String[]>] [-NetworkType <VirtualizationType[]>]
  [-AddressSpace <String[]>] [-Unmapped] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamRange -MappingToBlock <CimInstance> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamRange -MappingToSubnet <CimInstance> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AddressCategory AddressCategory[]:
    values:
    - Public
    - Private
    - Global
  -AddressFamily AddressFamily[]:
    required: true
    values:
    - IPv4
    - IPv6
  -AddressSpace String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -EndIPAddress IPAddress[]:
    required: true
  -ManagedByService,-MB String[]: ~
  -MappingToBlock CimInstance:
    required: true
  -MappingToSubnet CimInstance:
    required: true
  -NetworkType VirtualizationType[]:
    values:
    - NonVirtualized
    - Provider
    - Customer
  -ServiceInstance,-SI String[]: ~
  -StartIPAddress IPAddress[]:
    required: true
  -ThrottleLimit Int32: ~
  -Unmapped Switch: ~
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
