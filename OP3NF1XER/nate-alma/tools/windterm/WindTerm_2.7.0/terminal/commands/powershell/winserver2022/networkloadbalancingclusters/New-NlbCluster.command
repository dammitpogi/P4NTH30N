description: Creates a NLB cluster on the specified interface that is defined by the
  node and network adapter name
synopses:
- New-NlbCluster [[-HostName] <String>] [-InterfaceName] <String> [-ClusterName <String>]
  [-ClusterPrimaryIP] <IPAddress> [-SubnetMask <IPAddress>] [-DedicatedIP <IPAddress>]
  [-DedicatedIPSubnetMask <IPAddress>] [-Force] [-OperationMode <ClusterMode>] [<CommonParameters>]
options:
  -ClusterName,-Name,-CN,-N String: ~
  -ClusterPrimaryIP,-PrimaryIP,-IPAddress,-IP IPAddress:
    required: true
  -DedicatedIP,-DIP IPAddress: ~
  -DedicatedIPSubnetMask,-DIPSubnetMask IPAddress: ~
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -OperationMode,-Mode ClusterMode:
    values:
    - Unicast
    - Multicast
    - IgmpMulticast
  -SubnetMask IPAddress: ~
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
