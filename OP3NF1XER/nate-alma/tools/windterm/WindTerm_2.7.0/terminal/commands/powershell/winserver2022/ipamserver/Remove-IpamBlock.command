description: Removes an address block from IPAM
synopses:
- Remove-IpamBlock [-NetworkId] <String[]> [-StartIPAddress] <IPAddress[]> [-EndIPAddress]
  <IPAddress[]> [-DeleteAssociatedSubBlocks] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-IpamBlock -InputObject <CimInstance[]> [-DeleteAssociatedSubBlocks] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DeleteAssociatedSubBlocks Switch: ~
  -EndIPAddress IPAddress[]:
    required: true
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -NetworkId String[]:
    required: true
  -PassThru Switch: ~
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
