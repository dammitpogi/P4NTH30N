description: Gets a set of address blocks from IPAM
synopses:
- Get-IpamBlock -NetworkId <String[]> -StartIPAddress <IPAddress[]> -EndIPAddress
  <IPAddress[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamBlock [-AddressFamily] <AddressFamily[]> [[-AddressCategory] <AddressCategory[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamBlock -MappingToParentBlock <CimInstance> [-CimSession <CimSession[]>] [-ThrottleLimit
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
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -EndIPAddress IPAddress[]:
    required: true
  -MappingToParentBlock CimInstance:
    required: true
  -NetworkId String[]:
    required: true
  -StartIPAddress IPAddress[]:
    required: true
  -ThrottleLimit Int32: ~
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
