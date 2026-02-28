description: Configures monitoring for a service or an Event Tracing for Windows (ETW)
  event so that it is monitored on a virtual machine
synopses:
- Add-ClusterVMMonitoredItem [-Service <StringCollection>] [-EventLog <String>] [-EventSource
  <String>] [-EventId <Int32>] [-OverrideServiceRecoveryActions] [[-VirtualMachine]
  <String>] [-Wait <Int32>] [-Cluster <String>] [<CommonParameters>]
- Add-ClusterVMMonitoredItem [-Service <StringCollection>] [-EventLog <String>] [-EventSource
  <String>] [-EventId <Int32>] [-OverrideServiceRecoveryActions] [-VMId <Guid>] [-Wait
  <Int32>] [-Cluster <String>] [<CommonParameters>]
- Add-ClusterVMMonitoredItem [-Service <StringCollection>] [-EventLog <String>] [-EventSource
  <String>] [-EventId <Int32>] [-OverrideServiceRecoveryActions] [-Wait <Int32>] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -EventId Int32: ~
  -EventLog String: ~
  -EventSource String: ~
  -InputObject PSObject: ~
  -OverrideServiceRecoveryActions Switch: ~
  -Service StringCollection: ~
  -VMId Guid: ~
  -VirtualMachine,-VM String: ~
  -Wait Int32: ~
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
