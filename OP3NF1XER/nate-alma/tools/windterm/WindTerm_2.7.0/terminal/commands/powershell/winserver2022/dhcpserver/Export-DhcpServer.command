description: Exports the DHCP server service configuration and lease data
synopses:
- Export-DhcpServer [-File] <String> [-ScopeId <IPAddress[]>] [-Prefix <IPAddress[]>]
  [-Leases] [-Force] [-ComputerName <String>] [-CimSession <CimSession>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession,-Session CimSession: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -File String:
    required: true
  -Force Switch: ~
  -Leases Switch: ~
  -Prefix IPAddress[]: ~
  -ScopeId IPAddress[]: ~
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
