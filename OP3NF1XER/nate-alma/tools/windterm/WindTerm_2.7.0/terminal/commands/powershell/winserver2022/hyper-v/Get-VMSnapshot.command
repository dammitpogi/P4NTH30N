description: Gets the checkpoints associated with a virtual machine or checkpoint
synopses:
- Get-VMSnapshot [-VMName] <String[]> [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [[-Name] <String>] [-SnapshotType <SnapshotType>]
  [<CommonParameters>]
- Get-VMSnapshot [-VM] <VirtualMachine[]> [[-Name] <String>] [-SnapshotType <SnapshotType>]
  [<CommonParameters>]
- Get-VMSnapshot [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Id] <Guid> [<CommonParameters>]
- Get-VMSnapshot [[-Name] <String>] -ParentOf <VirtualMachineBase> [-SnapshotType
  <SnapshotType>] [<CommonParameters>]
- Get-VMSnapshot [[-Name] <String>] -ChildOf <VMSnapshot> [-SnapshotType <SnapshotType>]
  [<CommonParameters>]
options:
  -ChildOf VMSnapshot:
    required: true
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Id Guid:
    required: true
  -Name String: ~
  -ParentOf VirtualMachineBase:
    required: true
  -SnapshotType,-VMRecoveryCheckpoint SnapshotType:
    values:
    - Standard
    - Recovery
    - Planned
    - Missing
    - Replica
    - AppConsistentReplica
    - SyncedReplica
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
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
