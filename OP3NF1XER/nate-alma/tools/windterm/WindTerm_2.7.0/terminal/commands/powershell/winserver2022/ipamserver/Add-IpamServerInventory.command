description: Adds an infrastructure server to an IPAM database
synopses:
- Add-IpamServerInventory [-Name] <String> -ServerType <ServerRole[]> [-ManageabilityStatus
  <ManageabilityStatus>] [-ForestName <String>] [-Owner <String>] [-Description <String>]
  [-CustomConfiguration <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CustomConfiguration String: ~
  -Description String: ~
  -ForestName String: ~
  -ManageabilityStatus ManageabilityStatus:
    values:
    - Unspecified
    - Unmanaged
    - Managed
  -Name,-ServerName String:
    required: true
  -Owner String: ~
  -PassThru Switch: ~
  -ServerType ServerRole[]:
    required: true
    values:
    - DC
    - DNS
    - DHCP
    - NPS
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
