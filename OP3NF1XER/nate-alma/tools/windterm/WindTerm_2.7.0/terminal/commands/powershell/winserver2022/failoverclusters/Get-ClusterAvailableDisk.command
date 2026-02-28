description: Gets information about the disks that can support Failover Clustering
  and are visible to all nodes, but are not yet part of the set of clustered disks
synopses:
- Get-ClusterAvailableDisk [[-Cluster] <String>] [-Disk <CimInstance>] [-All] [-InputObject
  <PSObject>] [<CommonParameters>]
options:
  -All Switch: ~
  -Cluster String: ~
  -Disk CimInstance: ~
  -InputObject PSObject: ~
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
