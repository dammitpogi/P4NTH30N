description: Adds a multicast scope on the DHCP server
synopses:
- Add-DhcpServerv4MulticastScope [-ComputerName <String>] [-Name] <String> [-StartRange]
  <IPAddress> [-EndRange] <IPAddress> [-Description <String>] [-State <String>] [-LeaseDuration
  <TimeSpan>] [-PassThru] [-Ttl <UInt32>] [-ExpiryTime <DateTime>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -EndRange IPAddress:
    required: true
  -ExpiryTime DateTime: ~
  -LeaseDuration TimeSpan: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -StartRange IPAddress:
    required: true
  -State String:
    values:
    - Active
    - InActive
  -ThrottleLimit Int32: ~
  -Ttl UInt32: ~
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
