description: Removes a cryptographic key checkpoint or registry checkpoint for a resource
synopses:
- Remove-ClusterCheckpoint [[-ResourceName] <String>] [-Force] [-CheckpointName <String>]
  [-RegistryCheckpoint] [-CryptoCheckpoint] [-InputObject <PSObject>] [-Cluster <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CheckpointName String: ~
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -CryptoCheckpoint Switch: ~
  -Force Switch: ~
  -InputObject PSObject: ~
  -RegistryCheckpoint Switch: ~
  -ResourceName String: ~
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
