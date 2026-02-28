description: Removes monitoring of a service or event that is currently being monitored
  on a virtual machine
synopses:
- Remove-ClusterVMMonitoredItem [-InputObject <PSObject>] [-Service <StringCollection>]
  [-EventLog <String>] [-EventSource <String>] [-EventId <Int32>] [[-VirtualMachine]
  <String>] [-Wait <Int32>] [-Cluster <String>] [<CommonParameters>]
- Remove-ClusterVMMonitoredItem [-InputObject <PSObject>] [-Service <StringCollection>]
  [-EventLog <String>] [-EventSource <String>] [-EventId <Int32>] [-VMId <Guid>] [-Wait
  <Int32>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -EventId Int32: ~
  -EventLog String: ~
  -EventSource String: ~
  -InputObject PSObject: ~
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
