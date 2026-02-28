description: Adds an RRL exception list on the DNS server
synopses:
- Add-DnsServerResponseRateLimitingExceptionlist [[-ClientSubnet] <String>] [[-Fqdn]
  <String>] [[-ServerInterfaceIP] <String>] [[-Name] <String>] [[-Condition] <String>]
  [-PassThru] [-ComputerName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientSubnet String: ~
  -ComputerName,-Cn String: ~
  -Condition String:
    values:
    - AND
    - OR
  -Confirm,-cf Switch: ~
  -Fqdn String: ~
  -Name String: ~
  -PassThru Switch: ~
  -ServerInterfaceIP String: ~
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
