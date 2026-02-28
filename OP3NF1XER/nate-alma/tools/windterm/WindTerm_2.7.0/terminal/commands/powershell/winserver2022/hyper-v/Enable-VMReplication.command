description: Enables replication of a virtual machine
synopses:
- Enable-VMReplication [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-ReplicaServerName] <String> [-ReplicaServerPort]
  <Int32> [-AuthenticationType] <ReplicationAuthenticationType> [-CertificateThumbprint
  <String>] [-CompressionEnabled <Boolean>] [-ReplicateHostKvpItems <Boolean>] [-BypassProxyServer
  <Boolean>] [-EnableWriteOrderPreservationAcrossDisks <Boolean>] [-VSSSnapshotFrequencyHour
  <Int32>] [-RecoveryHistory <Int32>] [-ReplicationFrequencySec <Int32>] [-ExcludedVhd
  <HardDiskDrive[]>] [-ExcludedVhdPath <String[]>] [-AutoResynchronizeEnabled <Boolean>]
  [-AutoResynchronizeIntervalStart <TimeSpan>] [-AutoResynchronizeIntervalEnd <TimeSpan>]
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-VMReplication [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-AsReplica] [-AllowedPrimaryServer <String>]
  [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-VMReplication [-Credential <PSCredential[]>] [-VM] <VirtualMachine[]> [-ReplicaServerName]
  <String> [-ReplicaServerPort] <Int32> [-AuthenticationType] <ReplicationAuthenticationType>
  [-CertificateThumbprint <String>] [-CompressionEnabled <Boolean>] [-ReplicateHostKvpItems
  <Boolean>] [-BypassProxyServer <Boolean>] [-EnableWriteOrderPreservationAcrossDisks
  <Boolean>] [-VSSSnapshotFrequencyHour <Int32>] [-RecoveryHistory <Int32>] [-ReplicationFrequencySec
  <Int32>] [-ExcludedVhd <HardDiskDrive[]>] [-ExcludedVhdPath <String[]>] [-AutoResynchronizeEnabled
  <Boolean>] [-AutoResynchronizeIntervalStart <TimeSpan>] [-AutoResynchronizeIntervalEnd
  <TimeSpan>] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-VMReplication [-Credential <PSCredential[]>] [-VM] <VirtualMachine[]> [-AsReplica]
  [-AllowedPrimaryServer <String>] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowedPrimaryServer,-AllowedPS String: ~
  -AsJob Switch: ~
  -AsReplica Switch: ~
  -AuthenticationType,-AuthType ReplicationAuthenticationType:
    required: true
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
  -EnableWriteOrderPreservationAcrossDisks Boolean: ~
  -ExcludedVhd HardDiskDrive[]: ~
  -ExcludedVhdPath String[]: ~
  -Passthru Switch: ~
  -RecoveryHistory,-RecHist Int32: ~
  -ReplicaServerName,-ReplicaServer String:
    required: true
  -ReplicaServerPort,-ReplicaPort Int32:
    required: true
  -ReplicateHostKvpItems Boolean: ~
  -ReplicationFrequencySec,-RepFreq Int32: ~
  -VM VirtualMachine[]:
    required: true
  -VMName,-Name String[]:
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
