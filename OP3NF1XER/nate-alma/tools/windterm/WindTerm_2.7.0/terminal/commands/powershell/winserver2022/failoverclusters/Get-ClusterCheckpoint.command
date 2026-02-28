description: Retrieves a cryptographic key checkpoint or registry checkpoint for a
  resource
synopses:
- Get-ClusterCheckpoint [[-ResourceName] <StringCollection>] [-CheckpointName <String>]
  [-RegistryCheckpoint] [-CryptoCheckpoint] [-InputObject <PSObject>] [-Cluster <String>]
  [<CommonParameters>]
options:
  -CheckpointName String: ~
  -Cluster String: ~
  -CryptoCheckpoint Switch: ~
  -InputObject PSObject: ~
  -RegistryCheckpoint Switch: ~
  -ResourceName StringCollection: ~
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
