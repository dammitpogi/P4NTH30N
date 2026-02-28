description: Adds a DNS stub zone
synopses:
- Add-DnsServerStubZone [-LoadExisting] [-MasterServers] <IPAddress[]> [-ComputerName
  <String>] [-PassThru] [-Name] <String> [-ZoneFile <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerStubZone [-LoadExisting] [-MasterServers] <IPAddress[]> [-ComputerName
  <String>] [-PassThru] -NetworkId <String> [-ZoneFile <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerStubZone [-LoadExisting] [-MasterServers] <IPAddress[]> [-ComputerName
  <String>] [-PassThru] [-ReplicationScope] <String> [[-DirectoryPartitionName] <String>]
  -NetworkId <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerStubZone [-LoadExisting] [-MasterServers] <IPAddress[]> [-ComputerName
  <String>] [-PassThru] [-ReplicationScope] <String> [-Name] <String> [[-DirectoryPartitionName]
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DirectoryPartitionName String: ~
  -LoadExisting Switch: ~
  -MasterServers IPAddress[]:
    required: true
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
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
  -ZoneFile String: ~
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
