description: Starts the Cluster service on a node in a failover cluster
synopses:
- Start-ClusterNode [[-Name] <StringCollection>] [-ForceQuorum] [-ClearQuarantine]
  [-IgnorePersistentState] [-PreventQuorum] [-Wait <Int32>] [-InputObject <PSObject>]
  [-Cluster <String>] [<CommonParameters>]
options:
  -ClearQuarantine,-cq Switch: ~
  -Cluster String: ~
  -ForceQuorum,-fq,-FixQuorum Switch: ~
  -IgnorePersistentState,-ips Switch: ~
  -InputObject PSObject: ~
  -Name StringCollection: ~
  -PreventQuorum,-pq Switch: ~
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
