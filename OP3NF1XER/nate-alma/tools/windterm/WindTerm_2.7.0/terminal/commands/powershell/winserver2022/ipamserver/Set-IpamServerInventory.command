description: Modifies the properties of an infrastructure server in the IPAM server
  inventory
synopses:
- Set-IpamServerInventory [-Name] <String> [[-NewName] <String>] [-ManageabilityStatus
  <ManageabilityStatus>] [-Owner <String>] [-ServerType <ServerRole[]>] [-Description
  <String>] [-AddCustomConfiguration <String>] [-RemoveCustomConfiguration <String>]
  [-Force] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddCustomConfiguration String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -Force Switch: ~
  -ManageabilityStatus ManageabilityStatus:
    values:
    - Unspecified
    - Unmanaged
    - Managed
  -Name,-ServerName String:
    required: true
  -NewName String: ~
  -Owner String: ~
  -PassThru Switch: ~
  -RemoveCustomConfiguration String: ~
  -ServerType ServerRole[]:
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
