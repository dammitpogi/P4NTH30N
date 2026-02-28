description: Configures how the DHCP server service updates the DNS server with the
  client-related information
synopses:
- Set-DhcpServerv6DnsSetting [-ComputerName <String>] [-NameProtection <Boolean>]
  [-DeleteDnsRROnLeaseExpiry <Boolean>] [-DynamicUpdates <String>] [[-IPAddress] <IPAddress>]
  [[-Prefix] <IPAddress>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DeleteDnsRROnLeaseExpiry Boolean: ~
  -DynamicUpdates String:
    values:
    - Always
    - Never
    - OnClientRequest
  -IPAddress,-ReservedIP IPAddress: ~
  -NameProtection Boolean: ~
  -PassThru Switch: ~
  -Prefix IPAddress: ~
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
