description: Configures the DNS server and proxy server addresses of a Name Resolution
  Policy Table (NRPT) entry and configures the local name resolution property
synopses:
- Set-DAClientDnsConfiguration [-DnsSuffix <String>] [-DnsIPAddress <String[]>] [-ProxyServer
  <String>] [-Local <String>] [-ComputerName <String>] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DnsIPAddress,-DirectAccessDnsServers String[]: ~
  -DnsSuffix,-Namespace String: ~
  -Local,-SecureNameQueryFallback String:
    values:
    - FallbackSecure
    - FallbackPrivate
    - FallbackUnsecure
  -PassThru Switch: ~
  -ProxyServer,-DirectAccessProxyName String: ~
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
