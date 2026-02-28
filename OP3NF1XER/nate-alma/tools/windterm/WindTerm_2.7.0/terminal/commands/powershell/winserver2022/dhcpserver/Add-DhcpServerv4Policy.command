description: Adds a new policy either at the server level or at the scope level
synopses:
- Add-DhcpServerv4Policy [-ComputerName <String>] [-Name] <String> [-Condition] <String>
  [-Description <String>] [-ScopeId <IPAddress>] [-ProcessingOrder <UInt16>] [-RelayAgent
  <String[]>] [-RemoteId <String[]>] [-SubscriberId <String[]>] [-PassThru] [-LeaseDuration
  <TimeSpan>] [-Fqdn <String[]>] [-Enabled <Boolean>] [-VendorClass <String[]>] [-UserClass
  <String[]>] [-MacAddress <String[]>] [-CircuitId <String[]>] [-ClientId <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CircuitId String[]: ~
  -ClientId String[]: ~
  -ComputerName,-Cn String: ~
  -Condition String:
    required: true
    values:
    - And
    - Or
  -Confirm,-cf Switch: ~
  -Description String: ~
  -Enabled Boolean: ~
  -Fqdn String[]: ~
  -LeaseDuration TimeSpan: ~
  -MacAddress String[]: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -ProcessingOrder UInt16: ~
  -RelayAgent String[]: ~
  -RemoteId String[]: ~
  -ScopeId IPAddress: ~
  -SubscriberId String[]: ~
  -ThrottleLimit Int32: ~
  -UserClass String[]: ~
  -VendorClass String[]: ~
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
