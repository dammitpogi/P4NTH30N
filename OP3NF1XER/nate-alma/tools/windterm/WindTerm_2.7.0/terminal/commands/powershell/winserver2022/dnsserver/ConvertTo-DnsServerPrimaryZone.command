description: Converts a zone to a DNS primary zone
synopses:
- ConvertTo-DnsServerPrimaryZone [-ComputerName <String>] [-Name] <String> [-LoadExisting]
  [-PassThru] [-Force] [-ReplicationScope] <String> [[-DirectoryPartitionName] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- ConvertTo-DnsServerPrimaryZone [-ComputerName <String>] [-Name] <String> [-LoadExisting]
  [-PassThru] [-Force] -ZoneFile <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DirectoryPartitionName String: ~
  -Force Switch: ~
  -LoadExisting Switch: ~
  -Name,-ZoneName String:
    required: true
  -PassThru Switch: ~
  -ReplicationScope String:
    required: true
    values:
    - Forest
    - Domain
    - Legacy
    - Custom
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
