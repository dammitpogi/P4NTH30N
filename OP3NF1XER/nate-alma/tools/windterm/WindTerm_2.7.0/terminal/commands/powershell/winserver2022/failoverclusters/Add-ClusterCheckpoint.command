description: Adds a cryptographic key checkpoint or registry checkpoint for a resource
synopses:
- Add-ClusterCheckpoint [[-ResourceName] <String>] [-CryptoCheckpointName <String>]
  [-CryptoCheckpointType <String>] [-CryptoCheckpointKey <String>] [-RegistryCheckpoint
  <String>] [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -CryptoCheckpointKey String: ~
  -CryptoCheckpointName String: ~
  -CryptoCheckpointType String: ~
  -InputObject PSObject: ~
  -RegistryCheckpoint String: ~
  -ResourceName String: ~
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
