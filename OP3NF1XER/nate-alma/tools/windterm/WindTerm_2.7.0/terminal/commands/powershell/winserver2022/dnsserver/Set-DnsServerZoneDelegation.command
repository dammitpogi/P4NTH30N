description: Changes delegation settings for a child zone
synopses:
- Set-DnsServerZoneDelegation [-ComputerName <String>] [-PassThru] [[-ZoneScope] <String>]
  [-VirtualizationInstance <String>] [-InputObject] <CimInstance> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsServerZoneDelegation [-ComputerName <String>] [-PassThru] [[-ZoneScope] <String>]
  [-VirtualizationInstance <String>] [-ChildZoneName] <String> [-IPAddress] <IPAddress[]>
  [-NameServer] <String> [-Name] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -ChildZoneName String:
    required: true
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -IPAddress IPAddress[]:
    required: true
  -InputObject CimInstance:
    required: true
  -Name,-ZoneName String:
    required: true
  -NameServer String:
    required: true
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
