description: Performs a scan of cluster nodes for applicable updates and installs
  those updates through an updating run on the specified cluster
synopses:
- Invoke-CauRun [-MaxFailedNodes <Int32>] [-MaxRetriesPerNode <Int32>] [-NodeOrder
  <String[]>] [-PreUpdateScript <String>] [-PostUpdateScript <String>] [-ConfigurationName
  <String>] [-RequireAllNodesOnline] [-WarnAfter <TimeSpan>] [-StopAfter <TimeSpan>]
  [-RebootTimeoutMinutes <Int32>] [-SeparateReboots] [-EnableFirewallRules] [-FailbackMode
  <FailbackType>] [-SuspendClusterNodeTimeoutMinutes <Int32>] [-Force] [[-ClusterName]
  <String>] [[-CauPluginName] <String[]>] [[-Credential] <PSCredential>] [-CauPluginArguments
  <Hashtable[]>] [-RunPluginsSerially] [-StopOnPluginFailure] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Invoke-CauRun [-ForceRecovery] [-Force] [[-ClusterName] <String>] [[-Credential]
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CauPluginArguments Hashtable[]: ~
  -CauPluginName String[]: ~
  -ClusterName String: ~
  -ConfigurationName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -EnableFirewallRules Switch: ~
  -FailbackMode FailbackType:
    values:
    - NoFailback
    - Immediate
    - Policy
  -Force,-f Switch: ~
  -ForceRecovery,-Recover Switch:
    required: true
  -MaxFailedNodes Int32: ~
  -MaxRetriesPerNode Int32: ~
  -NodeOrder String[]: ~
  -PostUpdateScript String: ~
  -PreUpdateScript String: ~
  -RebootTimeoutMinutes Int32: ~
  -RequireAllNodesOnline Switch: ~
  -RunPluginsSerially Switch: ~
  -SeparateReboots Switch: ~
  -StopAfter TimeSpan: ~
  -StopOnPluginFailure Switch: ~
  -SuspendClusterNodeTimeoutMinutes Int32: ~
  -WarnAfter TimeSpan: ~
  -WhatIf,-wi Switch: ~
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
