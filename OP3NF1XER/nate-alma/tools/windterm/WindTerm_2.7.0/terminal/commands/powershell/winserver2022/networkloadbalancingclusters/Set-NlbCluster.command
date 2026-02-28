description: Edits the configuration of a NLB cluster
synopses:
- Set-NlbCluster [[-HostName] <String>] [-InterfaceName] <String> [-ClusterPrimaryIP
  <IPAddress>] [-Name <String>] [-OperationMode <ClusterMode>] [<CommonParameters>]
- Set-NlbCluster -InputObject <Cluster[]> [-ClusterPrimaryIP <IPAddress>] [-Name <String>]
  [-OperationMode <ClusterMode>] [<CommonParameters>]
options:
  -ClusterPrimaryIP,-PrimaryIP,-PIP IPAddress: ~
  -HostName,-Host,-HN,-H String: ~
  -InputObject Cluster[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -Name,-ClusterName String: ~
  -OperationMode ClusterMode:
    values:
    - Unicast
    - Multicast
    - IgmpMulticast
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
