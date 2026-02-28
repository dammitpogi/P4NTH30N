description: Adds a resource to a clustered role, or resource group, in a failover
  cluster
synopses:
- Add-ClusterResource [-Name] <String> [[-Group] <String>] [-ResourceType] <String>
  [-SeparateMonitor] [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -Group String: ~
  -InputObject PSObject: ~
  -Name String:
    required: true
  -ResourceType,-ResType,-Type String:
    required: true
  -SeparateMonitor Switch: ~
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
