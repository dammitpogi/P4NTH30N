description: Modifies settings of a replication group
synopses:
- Set-SRGroup [[-ComputerName] <String>] [-Name] <String> [-AddVolumeName] <String[]>
  [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-SRGroup [[-ComputerName] <String>] [-Name] <String> [-Force] [-RemoveVolumeName]
  <String[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-SRGroup [[-ComputerName] <String>] [-Name] <String> [-Force] [[-LogSizeInBytes]
  <UInt64>] [[-Description] <String>] [[-ReplicationMode] <ReplicationMode>] [[-Encryption]
  <Boolean>] [[-AllowVolumeResize] <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddVolumeName,-AV String[]:
    required: true
  -AllowVolumeResize,-VR Boolean: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Description,-D String: ~
  -Encryption,-ENC Boolean: ~
  -Force,-F Switch: ~
  -LogSizeInBytes,-LS UInt64: ~
  -Name,-N String:
    required: true
  -RemoveVolumeName,-RVN String[]:
    required: true
  -ReplicationMode,-RM ReplicationMode:
    values:
    - Synchronous
    - Asynchronous
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
