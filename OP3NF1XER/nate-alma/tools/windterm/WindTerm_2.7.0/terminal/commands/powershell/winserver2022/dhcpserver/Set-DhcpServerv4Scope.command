description: Sets the properties of an existing IPv4 scope on the DHCP server service
synopses:
- Set-DhcpServerv4Scope [-ActivatePolicies <Boolean>] [-PassThru] [-Type <String>]
  [-ScopeId] <IPAddress> [-Description <String>] [-LeaseDuration <TimeSpan>] [-Name
  <String>] [-NapEnable <Boolean>] [-NapProfile <String>] [-Delay <UInt16>] [-State
  <String>] [-SuperscopeName <String>] [-ComputerName <String>] [-MaxBootpClients
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-DhcpServerv4Scope [-ActivatePolicies <Boolean>] [-PassThru] [-Type <String>]
  [-ScopeId] <IPAddress> [-Description <String>] [-LeaseDuration <TimeSpan>] [-Name
  <String>] [-NapEnable <Boolean>] [-NapProfile <String>] [-Delay <UInt16>] [-State
  <String>] [-SuperscopeName <String>] [-ComputerName <String>] [-MaxBootpClients
  <UInt32>] -StartRange <IPAddress> -EndRange <IPAddress> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -Name String: ~
  -NapEnable Boolean: ~
  -NapProfile String: ~
  -PassThru Switch: ~
  -ScopeId IPAddress:
    required: true
  -StartRange IPAddress:
    required: true
  -State String:
    values:
    - Active
    - InActive
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
