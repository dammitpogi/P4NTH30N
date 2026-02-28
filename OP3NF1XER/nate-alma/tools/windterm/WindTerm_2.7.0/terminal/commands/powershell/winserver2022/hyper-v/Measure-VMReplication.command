description: Gets replication statistics and information associated with a virtual
  machine
synopses:
- Measure-VMReplication [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [[-VMName] <String[]>] [-ReplicaServerName <String>] [-PrimaryServerName
  <String>] [-ReplicationState <VMReplicationState>] [-ReplicationHealth <VMReplicationHealthState>]
  [-ReplicationMode <VMReplicationMode>] [-ReplicationRelationshipType <VMReplicationRelationshipType>]
  [-TrustGroup <String>] [<CommonParameters>]
- Measure-VMReplication [-VM] <VirtualMachine[]> [-ReplicationRelationshipType <VMReplicationRelationshipType>]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -PrimaryServerName,-PrimaryServer String: ~
  -ReplicaServerName,-ReplicaServer String: ~
  -ReplicationHealth,-Health VMReplicationHealthState:
    values:
    - NotApplicable
    - Normal
    - Warning
    - Critical
  -ReplicationMode,-Mode VMReplicationMode:
    values:
    - None
    - Primary
    - Replica
    - TestReplica
    - ExtendedReplica
  -ReplicationRelationshipType,-Relationship VMReplicationRelationshipType:
    values:
    - Simple
    - Extended
  -ReplicationState,-State VMReplicationState:
    values:
    - Disabled
    - ReadyForInitialReplication
    - InitialReplicationInProgress
    - WaitingForInitialReplication
    - Replicating
    - PreparedForFailover
    - FailedOverWaitingCompletion
    - FailedOver
    - Suspended
    - Error
    - WaitingForStartResynchronize
    - Resynchronizing
    - ResynchronizeSuspended
    - RecoveryInProgress
    - FailbackInProgress
    - FailbackComplete
    - WaitingForUpdateCompletion
    - UpdateError
    - WaitingForRepurposeCompletion
    - PreparedForSyncReplication
    - PreparedForGroupReverseReplication
    - FiredrillInProgress
  -TrustGroup String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName,-Name String[]: ~
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
