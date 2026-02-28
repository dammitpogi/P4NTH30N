description: Suspends activity on a failover cluster node, that is, pauses the node
synopses:
- Suspend-ClusterNode [[-Name] <StringCollection>] [-Drain] [-ForceDrain] [-Wait]
  [[-TargetNode] <String>] [-InputObject <PSObject>] [-Cluster <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -Drain Switch: ~
  -ForceDrain Switch: ~
  -InputObject PSObject: ~
  -Name StringCollection: ~
  -TargetNode String: ~
  -Wait Switch: ~
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
