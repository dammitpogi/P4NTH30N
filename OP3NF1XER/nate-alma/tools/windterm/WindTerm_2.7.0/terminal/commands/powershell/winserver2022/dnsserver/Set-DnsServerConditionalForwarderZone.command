description: Changes settings for a DNS conditional forwarder
synopses:
- Set-DnsServerConditionalForwarderZone [-Name] <String> [-ComputerName <String>]
  [-PassThru] [[-UseRecursion] <Boolean>] [[-MasterServers] <IPAddress[]>] [[-ForwarderTimeout]
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-DnsServerConditionalForwarderZone [-Name] <String> [-ComputerName <String>]
  [-PassThru] [-DirectoryPartitionName <String>] -ReplicationScope <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DirectoryPartitionName String: ~
  -ForwarderTimeout UInt32: ~
  -MasterServers IPAddress[]: ~
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
  -UseRecursion Boolean: ~
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
