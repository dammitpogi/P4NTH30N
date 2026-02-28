description: Edits the NLB cluster node settings
synopses:
- Set-NlbClusterNode [[-HostName] <String>] -InterfaceName <String> [-Reload] [-HostPriority
  <Int32>] [-InitialHostState <NodeInitialHostState>] [-RetainSuspended <Boolean>]
  [-Force] [<CommonParameters>]
- Set-NlbClusterNode -InputObject <Node[]> [-Reload] [-HostPriority <Int32>] [-InitialHostState
  <NodeInitialHostState>] [-RetainSuspended <Boolean>] [-Force] [<CommonParameters>]
options:
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -HostPriority,-Priority,-HP Int32: ~
  -InitialHostState,-IHS,-State NodeInitialHostState:
    values:
    - Started
    - Stopped
    - Suspended
  -InputObject Node[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -Reload,-R Switch: ~
  -RetainSuspended,-RS Boolean: ~
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
