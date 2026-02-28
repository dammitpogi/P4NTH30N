description: Adds a dedicated IP address to a Network Load Balancing (NLB) cluster
synopses:
- Add-NlbClusterNodeDip [-IP] <IPAddress> [-SubnetMask <IPAddress>] [-HostName <String>]
  -InterfaceName <String> [<CommonParameters>]
- Add-NlbClusterNodeDip -InputObject <Node[]> [-IP] <IPAddress> [-SubnetMask <IPAddress>]
  [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject Node[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
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
