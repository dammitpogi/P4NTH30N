description: Removes a node from the Network Load Balancing (NLB) cluster
synopses:
- Remove-NlbClusterNode [-PassThru] [[-HostName] <String>] [-InterfaceName <String>]
  [-Force] [<CommonParameters>]
- Remove-NlbClusterNode -InputObject <Node[]> [-PassThru] [-Force] [<CommonParameters>]
options:
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -InputObject Node[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -PassThru,-Pass Switch: ~
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
