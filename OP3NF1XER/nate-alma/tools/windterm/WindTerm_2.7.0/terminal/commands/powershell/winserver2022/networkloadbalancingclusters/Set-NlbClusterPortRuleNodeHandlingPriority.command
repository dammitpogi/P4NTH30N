description: Sets the host priority of a port rule for a specific Network Load Balancing
  (NLB) node
synopses:
- Set-NlbClusterPortRuleNodeHandlingPriority [-HostName <String>] -InterfaceName <String>
  -IP <IPAddress> [-Port] <UInt32> -HandlingPriority <Int32> [<CommonParameters>]
- Set-NlbClusterPortRuleNodeHandlingPriority -InputObject <PortRule[]> -HandlingPriority
  <Int32> [<CommonParameters>]
options:
  -HandlingPriority,-HP Int32:
    required: true
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject PortRule[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
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
