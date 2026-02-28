description: Configures high availability for a service that was not originally designed
  to run in a failover cluster
synopses:
- Add-ClusterGenericServiceRole -ServiceName <String> [-CheckpointKey <StringCollection>]
  [-Storage <StringCollection>] [-StaticAddress <StringCollection>] [-IgnoreNetwork
  <StringCollection>] [[-Name] <String>] [-Wait <Int32>] [-InputObject <PSObject>]
  [-Cluster <String>] [<CommonParameters>]
options:
  -CheckpointKey StringCollection: ~
  -Cluster String: ~
  -IgnoreNetwork StringCollection: ~
  -InputObject PSObject: ~
  -Name String: ~
  -ServiceName String:
    required: true
  -StaticAddress StringCollection: ~
  -Storage StringCollection: ~
  -Wait Int32: ~
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
