description: Adds an IP address block to IPAM
synopses:
- Add-IpamBlock [-NetworkId] <String> [[-StartIPAddress] <IPAddress>] [[-EndIPAddress]
  <IPAddress>] [-Rir <String>] [-RirReceivedDate <DateTime>] [-Description <String>]
  [-LastAssignedDate <DateTime>] [-Owner <String>] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -EndIPAddress IPAddress: ~
  -LastAssignedDate DateTime: ~
  -NetworkId String:
    required: true
  -Owner String: ~
  -PassThru Switch: ~
  -Rir String: ~
  -RirReceivedDate DateTime: ~
  -StartIPAddress IPAddress: ~
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
