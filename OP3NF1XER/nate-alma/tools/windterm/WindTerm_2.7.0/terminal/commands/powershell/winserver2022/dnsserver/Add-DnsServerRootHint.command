description: Adds root hints on a DNS server
synopses:
- Add-DnsServerRootHint [-ComputerName <String>] [-PassThru] [-InputObject] <CimInstance>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-DnsServerRootHint [-ComputerName <String>] [-PassThru] [-IPAddress] <IPAddress[]>
  [-NameServer] <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -IPAddress IPAddress[]:
    required: true
  -InputObject CimInstance:
    required: true
  -NameServer String:
    required: true
  -PassThru Switch: ~
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
