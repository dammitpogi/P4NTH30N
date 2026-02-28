description: Modifies the replication settings of a virtual machine
synopses:
- Set-VMReplication [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [[-ReplicaServerName] <String>] [[-ReplicaServerPort]
  <Int32>] [[-AuthenticationType] <ReplicationAuthenticationType>] [-CertificateThumbprint
  <String>] [-CompressionEnabled <Boolean>] [-ReplicateHostKvpItems <Boolean>] [-BypassProxyServer
  <Boolean>] [-EnableWriteOrderPreservationAcrossDisks <Boolean>] [-InitialReplicationStartTime
  <DateTime>] [-DisableVSSSnapshotReplication] [-VSSSnapshotFrequencyHour <Int32>]
  [-RecoveryHistory <Int32>] [-ReplicationFrequencySec <Int32>] [-ReplicatedDisks
  <HardDiskDrive[]>] [-ReplicatedDiskPaths <String[]>] [-Reverse] [-AutoResynchronizeEnabled
  <Boolean>] [-AutoResynchronizeIntervalStart <TimeSpan>] [-AutoResynchronizeIntervalEnd
  <TimeSpan>] [-AsReplica] [-UseBackup] [-AllowedPrimaryServer <String>] [-AsJob]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMReplication [-Credential <PSCredential[]>] [-VM] <VirtualMachine[]> [[-ReplicaServerName]
  <String>] [[-ReplicaServerPort] <Int32>] [[-AuthenticationType] <ReplicationAuthenticationType>]
  [-CertificateThumbprint <String>] [-CompressionEnabled <Boolean>] [-ReplicateHostKvpItems
  <Boolean>] [-BypassProxyServer <Boolean>] [-EnableWriteOrderPreservationAcrossDisks
  <Boolean>] [-InitialReplicationStartTime <DateTime>] [-DisableVSSSnapshotReplication]
  [-VSSSnapshotFrequencyHour <Int32>] [-RecoveryHistory <Int32>] [-ReplicationFrequencySec
  <Int32>] [-ReplicatedDisks <HardDiskDrive[]>] [-ReplicatedDiskPaths <String[]>]
  [-Reverse] [-AutoResynchronizeEnabled <Boolean>] [-AutoResynchronizeIntervalStart
  <TimeSpan>] [-AutoResynchronizeIntervalEnd <TimeSpan>] [-AsReplica] [-UseBackup]
  [-AllowedPrimaryServer <String>] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMReplication [-Credential <PSCredential[]>] [-VMReplication] <VMReplication[]>
  [[-ReplicaServerName] <String>] [[-ReplicaServerPort] <Int32>] [[-AuthenticationType]
  <ReplicationAuthenticationType>] [-CertificateThumbprint <String>] [-CompressionEnabled
  <Boolean>] [-ReplicateHostKvpItems <Boolean>] [-BypassProxyServer <Boolean>] [-EnableWriteOrderPreservationAcrossDisks
  <Boolean>] [-InitialReplicationStartTime <DateTime>] [-DisableVSSSnapshotReplication]
  [-VSSSnapshotFrequencyHour <Int32>] [-RecoveryHistory <Int32>] [-ReplicationFrequencySec
  <Int32>] [-ReplicatedDisks <HardDiskDrive[]>] [-ReplicatedDiskPaths <String[]>]
  [-Reverse] [-AutoResynchronizeEnabled <Boolean>] [-AutoResynchronizeIntervalStart
  <TimeSpan>] [-AutoResynchronizeIntervalEnd <TimeSpan>] [-AsReplica] [-UseBackup]
  [-AllowedPrimaryServer <String>] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowedPrimaryServer,-AllowedPS String: ~
  -AsJob Switch: ~
  -AsReplica Switch: ~
  -AuthenticationType,-AuthType ReplicationAuthenticationType:
    values:
    - Kerberos
    - Certificate
  -AutoResynchronizeEnabled,-AutoResync Boolean: ~
  -AutoResynchronizeIntervalEnd,-AutoResyncEnd TimeSpan: ~
  -AutoResynchronizeIntervalStart,-AutoResyncStart TimeSpan: ~
  -BypassProxyServer Boolean: ~
  -CertificateThumbprint,-Thumbprint,-Cert String: ~
  -CimSession CimSession[]: ~
  -CompressionEnabled Boolean: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DisableVSSSnapshotReplication,-DisableVSS Switch: ~
  -EnableWriteOrderPreservationAcrossDisks Boolean: ~
  -InitialReplicationStartTime,-IRTime DateTime: ~
  -Passthru Switch: ~
  -RecoveryHistory,-RecHist Int32: ~
  -ReplicaServerName,-ReplicaServer String: ~
  -ReplicaServerPort,-ReplicaPort Int32: ~
  -ReplicateHostKvpItems Boolean: ~
  -ReplicatedDiskPaths String[]: ~
  -ReplicatedDisks HardDiskDrive[]: ~
  -ReplicationFrequencySec,-RepFreq Int32: ~
  -Reverse Switch: ~
  -UseBackup Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName,-Name String[]:
    required: true
  -VMReplication VMReplication[]:
    required: true
  -VSSSnapshotFrequencyHour,-VSSFreq Int32: ~
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
