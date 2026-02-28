description: Adds a resource to the list of resources on which a particular resource
  depends, using AND as the connector, within a failover cluster
synopses:
- Add-ClusterResourceDependency [[-Resource] <String>] [[-Provider] <String>] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -InputObject PSObject: ~
  -Provider String: ~
  -Resource String: ~
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
