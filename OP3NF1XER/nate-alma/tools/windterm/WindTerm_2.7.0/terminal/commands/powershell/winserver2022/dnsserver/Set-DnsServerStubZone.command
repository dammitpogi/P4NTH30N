description: Changes settings for a DNS server stub zone
synopses:
- Set-DnsServerStubZone [-Name] <String> [-ComputerName <String>] [-PassThru] [-MasterServers
  <IPAddress[]>] [-LocalMasters <IPAddress[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsServerStubZone [-Name] <String> [-ComputerName <String>] [-PassThru] [-DirectoryPartitionName
  <String>] -ReplicationScope <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DirectoryPartitionName String: ~
  -LocalMasters IPAddress[]: ~
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
