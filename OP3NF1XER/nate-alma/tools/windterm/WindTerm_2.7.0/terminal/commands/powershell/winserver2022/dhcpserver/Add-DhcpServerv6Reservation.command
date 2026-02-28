description: Adds an IPv6 Reservation to an IPv6 prefix or scope
synopses:
- Add-DhcpServerv6Reservation [-ComputerName <String>] [-IPAddress] <IPAddress> [-ClientDuid]
  <String> [-Iaid] <UInt32> [[-Name] <String>] [-Description <String>] [-Prefix] <IPAddress>
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientDuid,-Duid String:
    required: true
  -ComputerName,-Cn,-ReservationServer String: ~
  -Confirm,-cf Switch: ~
  -Description,-ReservationDescription String: ~
  -IPAddress,-ReservedIP IPAddress:
    required: true
  -Iaid UInt32:
    required: true
  -Name,-HostName,-ReservationName String: ~
  -PassThru Switch: ~
  -Prefix,-ReservationScopeID IPAddress:
    required: true
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
