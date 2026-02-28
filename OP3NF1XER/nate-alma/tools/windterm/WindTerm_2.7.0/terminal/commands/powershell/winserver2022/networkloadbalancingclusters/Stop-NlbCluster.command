description: Stops all nodes of a NLB cluster
synopses:
- Stop-NlbCluster [-Drain] [-Timeout <UInt32>] [[-HostName] <String>] [[-InterfaceName]
  <String>] [<CommonParameters>]
- Stop-NlbCluster -InputObject <Cluster[]> [-Drain] [-Timeout <UInt32>] [<CommonParameters>]
options:
  -Drain,-D Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -InputObject Cluster[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
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
