description: Gets DNS server IP addresses from the TCP/IP properties on an interface
synopses:
- Get-DnsClientServerAddress [-InterfaceIndex <UInt32[]>] [[-InterfaceAlias] <String[]>]
  [-AddressFamily <AddressFamily[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AddressFamily,-Family AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InterfaceAlias String[]: ~
  -InterfaceIndex UInt32[]: ~
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
