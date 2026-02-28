description: Gets the properties of managed servers in the IPAM server inventory
synopses:
- Get-IpamServerInventory -Name <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamServerInventory [-AddressFamily <AddressFamily[]>] [-ServerType <ServerRole[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Name,-ServerName String:
    required: true
  -ServerType ServerRole[]:
    values:
    - DC
    - DNS
    - DHCP
    - NPS
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
