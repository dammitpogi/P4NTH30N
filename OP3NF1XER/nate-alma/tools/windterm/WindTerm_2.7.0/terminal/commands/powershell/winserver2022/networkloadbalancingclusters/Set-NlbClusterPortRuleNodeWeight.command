description: Sets the load weight of a port rule for a specific NLB node
synopses:
- Set-NlbClusterPortRuleNodeWeight [-HostName <String>] -InterfaceName <String> -IP
  <IPAddress> [-Port] <UInt32> [-Equal] [-LoadWeight <Int32>] [<CommonParameters>]
- Set-NlbClusterPortRuleNodeWeight -InputObject <PortRule[]> [-Equal] [-LoadWeight
  <Int32>] [<CommonParameters>]
options:
  -Equal,-E Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject PortRule[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -LoadWeight,-W Int32: ~
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
