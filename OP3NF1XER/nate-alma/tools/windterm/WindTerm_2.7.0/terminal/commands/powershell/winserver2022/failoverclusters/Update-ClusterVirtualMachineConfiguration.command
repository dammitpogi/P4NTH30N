description: Refreshes the configuration of a clustered virtual machine within a failover
  cluster
synopses:
- Update-ClusterVirtualMachineConfiguration [[-Name] <String>] [-VMId <Guid>] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -InputObject PSObject: ~
  -Name String: ~
  -VMId Guid: ~
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
