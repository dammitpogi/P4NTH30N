description: Imports the Dynamic Host Configuration Protocol (DHCP) server service
  configuration, and optionally lease data, from a file
synopses:
- Import-DhcpServer [-File] <String> [-BackupPath] <String> [-ScopeId <IPAddress[]>]
  [-Prefix <IPAddress[]>] [-ScopeOverwrite] [-Leases] [-ServerConfigOnly] [-Force]
  [-ComputerName <String>] [-CimSession <CimSession>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BackupPath String:
    required: true
  -CimSession,-Session CimSession: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -File String:
    required: true
  -Force Switch: ~
  -Leases Switch: ~
  -Prefix IPAddress[]: ~
  -ScopeId IPAddress[]: ~
  -ScopeOverwrite Switch: ~
  -ServerConfigOnly Switch: ~
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
