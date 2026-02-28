description: Controls specific properties of an object in a failover cluster, such
  as a resource, a group, or a network
synopses:
- Set-ClusterParameter [-InputObject <PSObject>] [-Create] [-Delete] [-Cluster <String>]
  [<CommonParameters>]
- Set-ClusterParameter [-InputObject <PSObject>] [[-Name] <String>] [[-Value] <PSObject>]
  [-Create] [-Delete] [-Cluster <String>] [<CommonParameters>]
- Set-ClusterParameter [-InputObject <PSObject>] [[-Multiple] <Hashtable>] [-Create]
  [-Delete] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -Create Switch: ~
  -Delete Switch: ~
  -InputObject PSObject: ~
  -Multiple Hashtable: ~
  -Name String: ~
  -Value PSObject: ~
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
