description: Sets the properties of a policy at the server level or at the specified
  scope level
synopses:
- Set-DhcpServerv4Policy [-ComputerName <String>] [-Description <String>] [-Name]
  <String> [[-ScopeId] <IPAddress>] [-Enabled <Boolean>] [-MacAddress <String[]>]
  [-Fqdn <String[]>] [-UserClass <String[]>] [-SubscriberId <String[]>] [-NewName
  <String>] [-ClientId <String[]>] [-PassThru] [-LeaseDuration <TimeSpan>] [-ProcessingOrder
  <UInt16>] [-RelayAgent <String[]>] [-RemoteId <String[]>] [-CircuitId <String[]>]
  [-Condition <String>] [-VendorClass <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CircuitId String[]: ~
  -ClientId String[]: ~
  -ComputerName,-Cn String: ~
  -Condition String:
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
  -NewName String: ~
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
