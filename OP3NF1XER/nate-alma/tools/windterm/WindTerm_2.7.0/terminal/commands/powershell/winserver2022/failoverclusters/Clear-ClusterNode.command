description: Clears the cluster configuration from a node that was evicted from a
  failover cluster
synopses:
- Clear-ClusterNode [[-Name] <StringCollection>] [-Force] [-Wait <Int32>] [-CleanupDisks]
  [-InputObject <PSObject>] [-Cluster <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CleanupDisks Switch: ~
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject PSObject: ~
  -Name StringCollection: ~
  -Wait Int32: ~
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
