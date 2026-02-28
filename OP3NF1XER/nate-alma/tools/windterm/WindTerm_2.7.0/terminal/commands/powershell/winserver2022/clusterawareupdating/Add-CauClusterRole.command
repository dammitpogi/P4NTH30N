description: Adds the CAU clustered role that provides the self-updating functionality
  to the specified cluster
synopses:
- Add-CauClusterRole [-VirtualComputerObjectName <String>] [-GroupName <String>] [-StartDate
  <DateTime>] [-DaysOfWeek <Weekdays>] [-WeeksOfMonth <Int32[]>] [-CauPluginName <String[]>]
  [-CauPluginArguments <Hashtable[]>] [-MaxFailedNodes <Int32>] [-MaxRetriesPerNode
  <Int32>] [-NodeOrder <String[]>] [-PreUpdateScript <String>] [-PostUpdateScript
  <String>] [-ConfigurationName <String>] [-RequireAllNodesOnline] [-WarnAfter <TimeSpan>]
  [-StopAfter <TimeSpan>] [-RebootTimeoutMinutes <Int32>] [-SeparateReboots] [-RunPluginsSerially]
  [-StopOnPluginFailure] [-EnableFirewallRules] [-FailbackMode <FailbackType>] [-SuspendClusterNodeTimeoutMinutes
  <Int32>] [[-ClusterName] <String>] [[-Credential] <PSCredential>] [-Force] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-CauClusterRole [-VirtualComputerObjectName <String>] [-GroupName <String>] [-StartDate
  <DateTime>] [-DaysOfWeek <Weekdays>] [-IntervalWeeks <Int32>] [-CauPluginName <String[]>]
  [-CauPluginArguments <Hashtable[]>] [-MaxFailedNodes <Int32>] [-MaxRetriesPerNode
  <Int32>] [-NodeOrder <String[]>] [-PreUpdateScript <String>] [-PostUpdateScript
  <String>] [-ConfigurationName <String>] [-RequireAllNodesOnline] [-WarnAfter <TimeSpan>]
  [-StopAfter <TimeSpan>] [-RebootTimeoutMinutes <Int32>] [-SeparateReboots] [-RunPluginsSerially]
  [-StopOnPluginFailure] [-EnableFirewallRules] [-FailbackMode <FailbackType>] [-SuspendClusterNodeTimeoutMinutes
  <Int32>] [[-ClusterName] <String>] [[-Credential] <PSCredential>] [-Force] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CauPluginArguments Hashtable[]: ~
  -CauPluginName String[]: ~
  -ClusterName String: ~
  -ConfigurationName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DaysOfWeek Weekdays:
    values:
    - None
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
  -EnableFirewallRules Switch: ~
  -FailbackMode FailbackType:
    values:
    - NoFailback
    - Immediate
    - Policy
  -Force,-f Switch: ~
  -GroupName String: ~
  -IntervalWeeks Int32: ~
  -MaxFailedNodes Int32: ~
  -MaxRetriesPerNode Int32: ~
  -NodeOrder String[]: ~
  -PostUpdateScript String: ~
  -PreUpdateScript String: ~
  -RebootTimeoutMinutes Int32: ~
  -RequireAllNodesOnline Switch: ~
  -RunPluginsSerially Switch: ~
  -SeparateReboots Switch: ~
  -StartDate DateTime: ~
  -StopAfter TimeSpan: ~
  -StopOnPluginFailure Switch: ~
  -SuspendClusterNodeTimeoutMinutes Int32: ~
  -VirtualComputerObjectName String: ~
  -WarnAfter TimeSpan: ~
  -WeeksOfMonth Int32[]: ~
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
