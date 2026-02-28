description: Registers a scheduled task on a failover cluster
synopses:
- Register-ClusteredScheduledTask [-InputObject] <CimInstance> [[-Cluster] <String>]
  [-TaskName] <String> [[-TaskType] <ClusterTaskTypeEnum>] [[-Resource] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Register-ClusteredScheduledTask [[-Cluster] <String>] [-TaskName] <String> [[-TaskType]
  <ClusterTaskTypeEnum>] [[-Resource] <String>] [-Xml] <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Register-ClusteredScheduledTask [[-Cluster] <String>] [-TaskName] <String> [[-TaskType]
  <ClusterTaskTypeEnum>] [[-Resource] <String>] [[-Settings] <CimInstance>] [[-Description]
  <String>] [[-Trigger] <CimInstance[]>] [-Action] <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Action CimInstance[]:
    required: true
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Cluster String: ~
  -Description String: ~
  -InputObject CimInstance:
    required: true
  -Resource String: ~
  -Settings CimInstance: ~
  -TaskName String:
    required: true
  -TaskType ClusterTaskTypeEnum:
    values:
    - ResourceSpecific
    - AnyNode
    - ClusterWide
  -ThrottleLimit Int32: ~
  -Trigger CimInstance[]: ~
  -Xml String:
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
