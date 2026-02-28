description: Creates a new authorization entry that allows one or more primary servers
  to replicate data to a specified Replica server
synopses:
- New-VMReplicationAuthorizationEntry [-AllowedPrimaryServer] <String> [-ReplicaStorageLocation]
  <String> [-TrustGroup] <String> [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowedPrimaryServer,-AllowedPS String:
    required: true
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -ReplicaStorageLocation,-StorageLoc String:
    required: true
  -TrustGroup String:
    required: true
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
