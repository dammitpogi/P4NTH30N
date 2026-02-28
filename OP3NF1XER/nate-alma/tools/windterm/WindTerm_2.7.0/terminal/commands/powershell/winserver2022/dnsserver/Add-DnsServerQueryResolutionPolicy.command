description: Adds a policy for query resolution to a DNS server
synopses:
- Add-DnsServerQueryResolutionPolicy [-PassThru] [-ComputerName <String>] [-Name]
  <String> [-Fqdn <String>] [-ECS <String>] [-ClientSubnet <String>] [-TimeOfDay <String>]
  [-TransportProtocol <String>] [-InternetProtocol <String>] [[-Action] <String>]
  [-ApplyOnRecursion] [-ServerInterfaceIP <String>] [-QType <String>] [-ProcessingOrder
  <UInt32>] [[-Condition] <String>] [-RecursionScope <String>] [-Disable] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerQueryResolutionPolicy [-PassThru] [-ComputerName <String>] [-ZoneName]
  <String> [-Name] <String> [-Fqdn <String>] [-ECS <String>] [-ClientSubnet <String>]
  [-TimeOfDay <String>] [-TransportProtocol <String>] [-InternetProtocol <String>]
  [[-Action] <String>] [-ServerInterfaceIP <String>] [-QType <String>] [-ProcessingOrder
  <UInt32>] [[-Condition] <String>] [-Disable] [-ZoneScope <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerQueryResolutionPolicy [-PassThru] [-ComputerName <String>] [-InputObject]
  <CimInstance> [[-ZoneName] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Action String:
    values:
    - ALLOW
    - DENY
    - IGNORE
  -ApplyOnRecursion Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientSubnet String: ~
  -ComputerName,-Cn String: ~
  -Condition String:
    values:
    - AND
    - OR
  -Confirm,-cf Switch: ~
  -Disable Switch: ~
  -ECS String: ~
  -Fqdn String: ~
  -InputObject CimInstance:
    required: true
  -InternetProtocol String: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -ProcessingOrder UInt32: ~
  -QType String: ~
  -RecursionScope String: ~
  -ServerInterfaceIP String: ~
  -ThrottleLimit Int32: ~
  -TimeOfDay String: ~
  -TransportProtocol String: ~
  -WhatIf,-wi Switch: ~
  -ZoneName String:
    required: true
  -ZoneScope String: ~
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
