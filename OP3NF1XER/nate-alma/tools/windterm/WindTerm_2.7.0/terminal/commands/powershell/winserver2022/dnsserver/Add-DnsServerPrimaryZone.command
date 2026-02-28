description: Adds a primary zone to a DNS server
synopses:
- Add-DnsServerPrimaryZone [-ResponsiblePerson <String>] [-DynamicUpdate <String>]
  [-LoadExisting] [-ComputerName <String>] [-PassThru] [-Name] <String> [-ReplicationScope]
  <String> [[-DirectoryPartitionName] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerPrimaryZone [-ResponsiblePerson <String>] [-DynamicUpdate <String>]
  [-LoadExisting] [-ComputerName <String>] [-PassThru] -NetworkId <String> -ZoneFile
  <String> [-VirtualizationInstance <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerPrimaryZone [-ResponsiblePerson <String>] [-DynamicUpdate <String>]
  [-LoadExisting] [-ComputerName <String>] [-PassThru] [-Name] <String> -ZoneFile
  <String> [-VirtualizationInstance <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerPrimaryZone [-ResponsiblePerson <String>] [-DynamicUpdate <String>]
  [-LoadExisting] [-ComputerName <String>] [-PassThru] [-ReplicationScope] <String>
  [[-DirectoryPartitionName] <String>] -NetworkId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DirectoryPartitionName String: ~
  -DynamicUpdate String:
    values:
    - None
    - Secure
    - NonsecureAndSecure
  -LoadExisting Switch: ~
  -Name,-ZoneName String:
    required: true
  -NetworkId String:
    required: true
  -PassThru Switch: ~
  -ReplicationScope String:
    required: true
    values:
    - Forest
    - Domain
    - Legacy
    - Custom
  -ResponsiblePerson String: ~
  -ThrottleLimit Int32: ~
  -VirtualizationInstance String: ~
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
