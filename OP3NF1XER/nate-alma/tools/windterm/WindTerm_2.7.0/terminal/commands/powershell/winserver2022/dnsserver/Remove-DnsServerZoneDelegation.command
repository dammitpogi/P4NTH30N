description: Removes a name server or delegation from a DNS zone
synopses:
- Remove-DnsServerZoneDelegation [-ComputerName <String>] [-PassThru] [-Force] [[-ZoneScope]
  <String>] [-VirtualizationInstance <String>] [-InputObject] <CimInstance> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-DnsServerZoneDelegation [-ComputerName <String>] [-PassThru] [-Force] [[-ZoneScope]
  <String>] [-VirtualizationInstance <String>] [[-NameServer] <String>] [-ChildZoneName]
  <String> [-Name] <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -ChildZoneName String:
    required: true
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject CimInstance:
    required: true
  -Name,-ZoneName String:
    required: true
  -NameServer String: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -VirtualizationInstance String: ~
  -WhatIf,-wi Switch: ~
  -ZoneScope String: ~
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
