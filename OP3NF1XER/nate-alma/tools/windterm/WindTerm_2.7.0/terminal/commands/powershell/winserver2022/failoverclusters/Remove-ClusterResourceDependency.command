description: Removes a dependency between two resources in a clustered role within
  a failover cluster
synopses:
- Remove-ClusterResourceDependency [[-Resource] <String>] [[-Provider] <String>] [-InputObject
  <PSObject>] [-Cluster <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -InputObject PSObject: ~
  -Provider String: ~
  -Resource String: ~
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
