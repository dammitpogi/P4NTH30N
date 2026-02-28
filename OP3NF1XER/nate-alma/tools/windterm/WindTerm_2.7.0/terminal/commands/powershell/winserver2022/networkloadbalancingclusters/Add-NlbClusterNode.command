description: Adds a new node to the Network Load Balancing (NLB) cluster
synopses:
- Add-NlbClusterNode [-HostName <String>] -InterfaceName <String> [-NewNodeName] <String>
  [-NewNodeInterface] <String> [-Force] [<CommonParameters>]
- Add-NlbClusterNode -InputObject <Cluster[]> [-NewNodeName] <String> [-NewNodeInterface]
  <String> [-Force] [<CommonParameters>]
options:
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -InputObject Cluster[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -NewNodeInterface,-NewInterface,-NI String:
    required: true
  -NewNodeName,-NewNode,-NN String:
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
