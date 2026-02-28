description: Enables a port rule on a NLB cluster or on a specific node in the cluster
synopses:
- Enable-NlbClusterPortRule [-ClusterWide] [-HostName <String>] [-InterfaceName <String>]
  [-IP <IPAddress>] [-Port] <UInt32> [<CommonParameters>]
- Enable-NlbClusterPortRule -InputObject <PortRule[]> [<CommonParameters>]
options:
  -ClusterWide,-Cluster,-C Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject PortRule[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -Port,-P UInt32:
    required: true
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
