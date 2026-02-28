description: Moves the ownership of a clustered virtual machine to a different node
synopses:
- Move-ClusterVirtualMachineRole [[-Name] <String>] [[-Node] <String>] [-Cancel] [-MigrationType
  <VmMigrationType>] [-IgnoreLocked] [-VMId <Guid>] [-Wait <Int32>] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cancel Switch: ~
  -Cluster String: ~
  -IgnoreLocked Switch: ~
  -InputObject PSObject: ~
  -MigrationType VmMigrationType:
    values:
    - TurnOff
    - Quick
    - Shutdown
    - ShutdownForce
    - Live
  -Name String: ~
  -Node String: ~
  -VMId Guid: ~
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
