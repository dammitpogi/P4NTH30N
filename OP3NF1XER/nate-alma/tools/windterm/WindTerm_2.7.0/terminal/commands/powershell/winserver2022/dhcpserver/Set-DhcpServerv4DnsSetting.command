description: Configures how the DHCP server service updates the DNS server with the
  client-related information
synopses:
- Set-DhcpServerv4DnsSetting [-ComputerName <String>] [-NameProtection <Boolean>]
  [-UpdateDnsRRForOlderClients <Boolean>] [-DeleteDnsRROnLeaseExpiry <Boolean>] [-DynamicUpdates
  <String>] [[-IPAddress] <IPAddress>] [[-ScopeId] <IPAddress>] [-PassThru] [-PolicyName
  <String>] [-DisableDnsPtrRRUpdate <Boolean>] [-DnsSuffix <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DeleteDnsRROnLeaseExpiry Boolean: ~
  -DisableDnsPtrRRUpdate Boolean: ~
  -DnsSuffix String: ~
  -DynamicUpdates String:
    values:
    - Always
    - Never
    - OnClientRequest
  -IPAddress,-ReservedIP IPAddress: ~
  -NameProtection Boolean: ~
  -PassThru Switch: ~
  -PolicyName String: ~
  -ScopeId IPAddress: ~
  -ThrottleLimit Int32: ~
  -UpdateDnsRRForOlderClients Boolean: ~
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
