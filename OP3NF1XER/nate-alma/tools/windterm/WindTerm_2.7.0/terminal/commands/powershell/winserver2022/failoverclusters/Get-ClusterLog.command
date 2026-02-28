description: Creates a log file for all nodes, or a specific a node, in a failover
  cluster
synopses:
- Get-ClusterLog [[-Node] <StringCollection>] [-Destination <String>] [-TimeSpan <UInt32>]
  [-UseLocalTime] [-SkipClusterState] [-Health] [-InputObject <PSObject>] [-Cluster
  <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -Destination String: ~
  -Health Switch: ~
  -InputObject PSObject: ~
  -Node StringCollection: ~
  -SkipClusterState,-scs Switch: ~
  -TimeSpan,-Span UInt32: ~
  -UseLocalTime,-lt Switch: ~
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
