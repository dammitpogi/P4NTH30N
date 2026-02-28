description: Suspends a specific node in a NLB cluster
synopses:
- Suspend-NlbClusterNode [[-HostName] <String>] [-InterfaceName <String>] [<CommonParameters>]
- Suspend-NlbClusterNode -InputObject <Node[]> [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -InputObject Node[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
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
