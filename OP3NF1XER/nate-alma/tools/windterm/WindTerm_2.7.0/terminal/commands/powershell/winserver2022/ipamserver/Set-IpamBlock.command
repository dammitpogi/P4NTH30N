description: Modifies an IP address block in IPAM
synopses:
- Set-IpamBlock [-NetworkId] <String[]> [-StartIPAddress] <IPAddress[]> [-EndIPAddress]
  <IPAddress[]> [-NewNetworkId <String>] [-NewStartIpAddress <IPAddress>] [-NewEndIpAddress
  <IPAddress>] [-Rir <String>] [-RirReceivedDate <DateTime>] [-Description <String>]
  [-LastAssignedDate <DateTime>] [-Owner <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamBlock -InputObject <CimInstance[]> [-NewNetworkId <String>] [-NewStartIpAddress
  <IPAddress>] [-NewEndIpAddress <IPAddress>] [-Rir <String>] [-RirReceivedDate <DateTime>]
  [-Description <String>] [-LastAssignedDate <DateTime>] [-Owner <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -EndIPAddress IPAddress[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -LastAssignedDate DateTime: ~
  -NetworkId String[]:
    required: true
  -NewEndIpAddress IPAddress: ~
  -NewNetworkId String: ~
  -NewStartIpAddress IPAddress: ~
  -Owner String: ~
  -PassThru Switch: ~
  -Rir String: ~
  -RirReceivedDate DateTime: ~
  -StartIPAddress IPAddress[]:
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
