description: Adds an IPv4 scope on the DHCP server service
synopses:
- Add-DhcpServerv4Scope [-ComputerName <String>] [-StartRange] <IPAddress> [-EndRange]
  <IPAddress> [-Name] <String> [-Description <String>] [-State <String>] [-SuperscopeName
  <String>] [-MaxBootpClients <UInt32>] [-ActivatePolicies <Boolean>] [-PassThru]
  [-NapEnable] [-NapProfile <String>] [-Delay <UInt16>] [-LeaseDuration <TimeSpan>]
  [-SubnetMask] <IPAddress> [-Type <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ActivatePolicies Boolean: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Delay UInt16: ~
  -Description String: ~
  -EndRange IPAddress:
    required: true
  -LeaseDuration TimeSpan: ~
  -MaxBootpClients UInt32: ~
  -Name String:
    required: true
  -NapEnable Switch: ~
  -NapProfile String: ~
  -PassThru Switch: ~
  -StartRange IPAddress:
    required: true
  -State String:
    values:
    - Active
    - InActive
  -SubnetMask IPAddress:
    required: true
  -SuperscopeName String: ~
  -ThrottleLimit Int32: ~
  -Type String:
    values:
    - Dhcp
    - Bootp
    - Both
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
