description: Resumes a virtual machine replication that is in a state of Paused, Error,
  Resynchronization Required, or Suspended
synopses:
- Resume-VMReplication [-ComputerName <String[]>] [-VMName] <String[]> [-ReplicationRelationshipType
  <VMReplicationRelationshipType>] [-ResynchronizeStartTime <DateTime>] [-Resynchronize]
  [-AsJob] [-Continue] [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Resume-VMReplication [-VM] <VirtualMachine[]> [-ReplicationRelationshipType <VMReplicationRelationshipType>]
  [-ResynchronizeStartTime <DateTime>] [-Resynchronize] [-AsJob] [-Continue] [-Passthru]
  [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Resume-VMReplication [-VMReplication] <VMReplication[]> [-ResynchronizeStartTime
  <DateTime>] [-Resynchronize] [-AsJob] [-Continue] [-Passthru] [-CimSession <CimSession[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Continue Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -ReplicationRelationshipType,-Relationship VMReplicationRelationshipType:
    values:
    - Simple
    - Extended
  -Resynchronize,-Resync Switch: ~
  -ResynchronizeStartTime,-ResyncStart DateTime: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMReplication VMReplication[]:
    required: true
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
