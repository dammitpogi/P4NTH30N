description: Stops the Cluster service on all nodes in a failover cluster, which will
  stop all services and applications configured in the cluster
synopses:
- Stop-Cluster [[-Cluster] <String>] [-Force] [-Wait <Int32>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Stop-Cluster [-Force] [-Wait <Int32>] [-InputObject <PSObject>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Cluster,-Name String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject PSObject: ~
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
