description: Modifies the properties of a multicast scope
synopses:
- Set-DhcpServerv4MulticastScope [-ComputerName <String>] [-Description <String>]
  [-EndRange <IPAddress>] [-LeaseDuration <TimeSpan>] [-Name] <String> [-PassThru]
  [-StartRange <IPAddress>] [-State <String>] [-Ttl <UInt32>] [-NewName <String>]
  [-ExpiryTime <DateTime>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -EndRange IPAddress: ~
  -ExpiryTime DateTime: ~
  -LeaseDuration TimeSpan: ~
  -Name String:
    required: true
  -NewName String: ~
  -PassThru Switch: ~
  -StartRange IPAddress: ~
  -State String: ~
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
