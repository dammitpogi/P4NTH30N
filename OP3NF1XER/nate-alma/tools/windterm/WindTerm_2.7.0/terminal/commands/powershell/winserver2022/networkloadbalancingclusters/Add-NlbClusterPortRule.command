description: Adds a new port rule to a Network Load Balancing (NLB) cluster
synopses:
- Add-NlbClusterPortRule [-HostName <String>] -InterfaceName <String> [-IP <IPAddress>]
  [-Protocol <PortRuleProtocol>] [-StartPort] <Int32> [-EndPort] <Int32> [-Mode <PortRuleFilteringMode>]
  [-Affinity <PortRuleAffinity>] [-Timeout <UInt32>] [<CommonParameters>]
- Add-NlbClusterPortRule -InputObject <Cluster[]> [-IP <IPAddress>] [-Protocol <PortRuleProtocol>]
  [-StartPort] <Int32> [-EndPort] <Int32> [-Mode <PortRuleFilteringMode>] [-Affinity
  <PortRuleAffinity>] [-Timeout <UInt32>] [<CommonParameters>]
options:
  -Affinity,-A PortRuleAffinity:
    values:
    - Single
    - None
    - Network
  -EndPort,-E Int32:
    required: true
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject Cluster[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -Mode,-M PortRuleFilteringMode:
    values:
    - Multiple
    - Single
    - Disabled
  -Protocol,-PTCL PortRuleProtocol:
    values:
    - Both
    - Tcp
    - Udp
  -StartPort,-S Int32:
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
