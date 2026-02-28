description: Specifies which nodes can own a resource in a failover cluster or specifies
  the order of preference among owner nodes for a clustered role, or resource group
synopses:
- Set-ClusterOwnerNode [-Resource <String>] [-Group <String>] -Owners <StringCollection>
  [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -Group String: ~
  -InputObject PSObject: ~
  -Owners StringCollection:
    required: true
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
