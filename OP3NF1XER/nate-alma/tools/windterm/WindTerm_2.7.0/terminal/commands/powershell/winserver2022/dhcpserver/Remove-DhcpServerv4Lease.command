description: Deletes IPv4 address lease records from the DHCP server service
synopses:
- Remove-DhcpServerv4Lease [-PassThru] [-ComputerName <String>] -IPAddress <IPAddress[]>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-DhcpServerv4Lease [-PassThru] [-ComputerName <String>] [-ScopeId] <IPAddress>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-DhcpServerv4Lease [-PassThru] [-ComputerName <String>] [-ScopeId] <IPAddress>
  [-ClientId] <String[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-DhcpServerv4Lease [-PassThru] [-ComputerName <String>] [-BadLeases] [[-ScopeId]
  <IPAddress>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BadLeases Switch:
    required: true
  -CimSession,-Session CimSession[]: ~
  -ClientId String[]:
    required: true
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -IPAddress IPAddress[]:
    required: true
  -PassThru Switch: ~
  -ScopeId IPAddress:
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
