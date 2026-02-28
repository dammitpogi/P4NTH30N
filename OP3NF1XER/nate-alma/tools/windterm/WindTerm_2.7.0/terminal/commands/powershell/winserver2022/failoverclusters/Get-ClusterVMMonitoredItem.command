description: Gets the list of services and events currently being monitored in the
  virtual machine
synopses:
- Get-ClusterVMMonitoredItem [[-VirtualMachine] <String>] [-Wait <Int32>] [-Cluster
  <String>] [<CommonParameters>]
- Get-ClusterVMMonitoredItem [-VMId <Guid>] [-Wait <Int32>] [-Cluster <String>] [<CommonParameters>]
- Get-ClusterVMMonitoredItem [-Wait <Int32>] [-InputObject <PSObject>] [-Cluster <String>]
  [<CommonParameters>]
options:
  -Cluster String: ~
  -InputObject PSObject: ~
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
