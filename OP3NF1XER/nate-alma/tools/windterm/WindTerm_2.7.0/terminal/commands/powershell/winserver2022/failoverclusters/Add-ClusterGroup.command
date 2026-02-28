description: Adds an empty resource group to the failover cluster configuration, in
  preparation for adding clustered resources to the group
synopses:
- Add-ClusterGroup [-Name] <StringCollection> [[-GroupType] <GroupType>] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -GroupType GroupType:
    values:
    - Cluster
    - AvailableStorage
    - Temporary
    - ClusterSharedVolume
    - ClusterStoragePool
    - FileServer
    - DhcpServer
    - Dtc
    - Msmq
    - Wins
    - StandAloneDfs
    - GenericApplication
    - GenericService
    - GenericScript
    - IScsiNameService
    - VirtualMachine
    - TsSessionBroker
    - IScsiTarget
    - ScaleoutFileServer
    - VMReplicaBroker
    - TaskScheduler
    - Unknown
  -InputObject PSObject: ~
  -Name StringCollection:
    required: true
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
