description: Converts a primary zone or stub zone to a secondary zone
synopses:
- ConvertTo-DnsServerSecondaryZone [-ZoneFile] <String> [-MasterServers] <IPAddress[]>
  [-Name] <String> [-ComputerName <String>] [-PassThru] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -MasterServers IPAddress[]:
    required: true
  -Name,-ZoneName String:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
  -ZoneFile String:
    required: true
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
