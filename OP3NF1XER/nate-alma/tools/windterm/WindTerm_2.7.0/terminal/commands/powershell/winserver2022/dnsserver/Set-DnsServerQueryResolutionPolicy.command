description: Updates settings of a query resolution policy on a DNS server
synopses:
- Set-DnsServerQueryResolutionPolicy [-PassThru] [-ComputerName <String>] -Name <String>
  [-TransportProtocol <String>] [-TimeOfDay <String>] [-RecursionScope <String>] [-ServerInterfaceIP
  <String>] [-QType <String>] [-ProcessingOrder <UInt32>] [-ECS <String>] [-ClientSubnet
  <String>] [-Condition <String>] [-InternetProtocol <String>] [-Fqdn <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsServerQueryResolutionPolicy [-PassThru] [-ComputerName <String>] [-ZoneName]
  <String> -Name <String> [-TransportProtocol <String>] [-TimeOfDay <String>] [-ServerInterfaceIP
  <String>] [-QType <String>] [-ProcessingOrder <UInt32>] [-ECS <String>] [-ClientSubnet
  <String>] [-Condition <String>] [-InternetProtocol <String>] [-Fqdn <String>] [-ZoneScope
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-DnsServerQueryResolutionPolicy [-PassThru] [-ComputerName <String>] [-InputObject]
  <CimInstance> [[-ZoneName] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
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
