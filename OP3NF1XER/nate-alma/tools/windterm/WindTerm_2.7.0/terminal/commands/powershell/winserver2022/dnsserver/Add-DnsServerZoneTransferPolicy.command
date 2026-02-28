description: Adds a zone transfer policy to a DNS server
synopses:
- Add-DnsServerZoneTransferPolicy [-ComputerName <String>] [-PassThru] [[-Action]
  <String>] [-ClientSubnet <String>] [[-Condition] <String>] [-InternetProtocol <String>]
  [-Disable] [-Name] <String> [-ProcessingOrder <UInt32>] [-ServerInterfaceIP <String>]
  [-TimeOfDay <String>] [-TransportProtocol <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerZoneTransferPolicy [-ComputerName <String>] [-PassThru] [-ZoneName]
  <String> [[-Action] <String>] [-ClientSubnet <String>] [[-Condition] <String>] [-InternetProtocol
  <String>] [-Disable] [-Name] <String> [-ProcessingOrder <UInt32>] [-ServerInterfaceIP
  <String>] [-TimeOfDay <String>] [-TransportProtocol <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerZoneTransferPolicy [-ComputerName <String>] [-PassThru] [-InputObject]
  <CimInstance> [[-ZoneName] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Action String:
    values:
    - DENY
    - IGNORE
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
  -InputObject CimInstance:
    required: true
  -InternetProtocol String: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -ProcessingOrder UInt32: ~
  -ServerInterfaceIP String: ~
  -ThrottleLimit Int32: ~
  -TimeOfDay String: ~
  -TransportProtocol String: ~
  -WhatIf,-wi Switch: ~
  -ZoneName String:
    required: true
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
