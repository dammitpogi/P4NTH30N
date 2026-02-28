description: Removes a clustered role, also called a resource group, from a failover
  cluster
synopses:
- Remove-ClusterGroup [-VMId <Guid>] [[-Name] <StringCollection>] [-Force] [-RemoveResources]
  [-InputObject <PSObject>] [-Cluster <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject PSObject: ~
  -Name StringCollection: ~
  -RemoveResources Switch: ~
  -VMId Guid: ~
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
