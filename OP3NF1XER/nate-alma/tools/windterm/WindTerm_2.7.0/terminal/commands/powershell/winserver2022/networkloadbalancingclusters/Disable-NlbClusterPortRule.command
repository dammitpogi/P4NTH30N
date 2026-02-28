description: Disables a port rule on a Network Load Balancing (NLB) cluster or on
  a specific host in the cluster
synopses:
- Disable-NlbClusterPortRule [-Drain] [-Timeout <UInt32>] [-ClusterWide] [-HostName
  <String>] [-InterfaceName <String>] [-IP <IPAddress>] [-Port] <UInt32> [<CommonParameters>]
- Disable-NlbClusterPortRule -InputObject <PortRule[]> [-Drain] [-Timeout <UInt32>]
  [<CommonParameters>]
options:
  -ClusterWide,-Cluster,-C Switch: ~
  -Drain,-D Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject PortRule[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -Port,-P UInt32:
    required: true
  -Timeout,-T UInt32: ~
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
