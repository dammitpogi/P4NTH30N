description: Moves a clustered role (a resource group) from one node to another in
  a failover cluster
synopses:
- Move-ClusterGroup [[-Name] <String>] [[-Node] <String>] [-IgnoreLocked] [-Wait <Int32>]
  [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -IgnoreLocked Switch: ~
  -InputObject PSObject: ~
  -Name String: ~
  -Node String: ~
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
