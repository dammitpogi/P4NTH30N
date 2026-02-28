description: Modifies an authorization entry on a Replica server
synopses:
- Set-VMReplicationAuthorizationEntry [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-AllowedPrimaryServer] <String> [[-ReplicaStorageLocation]
  <String>] [[-TrustGroup] <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMReplicationAuthorizationEntry [-VMReplicationAuthorizationEntry] <VMReplicationAuthorizationEntry[]>
  [[-ReplicaStorageLocation] <String>] [[-TrustGroup] <String>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllowedPrimaryServer,-AllowedPS String:
    required: true
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -ReplicaStorageLocation,-StorageLoc String: ~
  -TrustGroup String: ~
  -VMReplicationAuthorizationEntry,-VMRepAuthEntry VMReplicationAuthorizationEntry[]:
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
