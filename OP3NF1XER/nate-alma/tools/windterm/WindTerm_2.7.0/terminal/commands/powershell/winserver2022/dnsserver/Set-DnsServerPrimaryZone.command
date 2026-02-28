description: Changes settings for a DNS primary zone
synopses:
- Set-DnsServerPrimaryZone [-Name] <String> [-ComputerName <String>] [-PassThru] [-AllowedDcForNsRecordsAutoCreation
  <String[]>] [-DynamicUpdate <String>] [-Notify <String>] [-NotifyServers <IPAddress[]>]
  [-SecondaryServers <IPAddress[]>] [-SecureSecondaries <String>] [-IgnorePolicies
  <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-DnsServerPrimaryZone [-Name] <String> [-ComputerName <String>] [-PassThru] -ZoneFile
  <String> [-VirtualizationInstance <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsServerPrimaryZone [-Name] <String> [-ComputerName <String>] [-PassThru] -ReplicationScope
  <String> [-DirectoryPartitionName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowedDcForNsRecordsAutoCreation String[]: ~
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
  -IgnorePolicies Boolean: ~
  -Name,-ZoneName String:
    required: true
  -Notify String:
    values:
    - NoNotify
    - Notify
    - NotifyServers
  -NotifyServers IPAddress[]: ~
  -PassThru Switch: ~
  -ReplicationScope String:
    required: true
    values:
    - Forest
    - Domain
    - Legacy
    - Custom
  -SecondaryServers IPAddress[]: ~
  -SecureSecondaries String:
    values:
    - NoTransfer
    - TransferAnyServer
    - TransferToZoneNameServer
    - TransferToSecureServers
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
