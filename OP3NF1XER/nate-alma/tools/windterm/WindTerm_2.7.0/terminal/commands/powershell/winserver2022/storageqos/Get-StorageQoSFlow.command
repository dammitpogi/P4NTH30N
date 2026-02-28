description: Retrieves performance metrics on an I/O flow that is monitored by Storage
  QoS
synopses:
- Get-StorageQoSFlow [[-FlowId] <Guid>] [[-InitiatorId] <String>] [[-FilePath] <String>]
  [[-VolumeId] <String>] [[-InitiatorName] <String>] [[-InitiatorNodeName] <String>]
  [[-StorageNodeName] <String>] [[-Status] <Status>] [-IncludeHidden] [-AsJob] [-CimSession
  <CimSession>] [-ThrottleLimit <Int32>] [<CommonParameters>]
- Get-StorageQoSFlow [-Policy] <CimInstance> [-AsJob] [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -FilePath String: ~
  -FlowId Guid: ~
  -IncludeHidden Switch: ~
  -InitiatorId String: ~
  -InitiatorName String: ~
  -InitiatorNodeName String: ~
  -Policy CimInstance:
    required: true
  -Status Status:
    values:
    - Ok
    - InsufficientThroughput
    - UnknownPolicyId
    - LostCommunication
  -StorageNodeName String: ~
  -ThrottleLimit Int32: ~
  -VolumeId String: ~
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
