description: Starts replication of a virtual machine
synopses:
- Start-VMInitialReplication [-ComputerName <String[]>] [-VMName] <String[]> [-DestinationPath
  <String>] [-InitialReplicationStartTime <DateTime>] [-UseBackup] [-AsJob] [-Passthru]
  [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Start-VMInitialReplication [-VM] <VirtualMachine[]> [-DestinationPath <String>]
  [-InitialReplicationStartTime <DateTime>] [-UseBackup] [-AsJob] [-Passthru] [-CimSession
  <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Start-VMInitialReplication [-VMReplication] <VMReplication[]> [-DestinationPath
  <String>] [-InitialReplicationStartTime <DateTime>] [-UseBackup] [-AsJob] [-Passthru]
  [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DestinationPath,-IRLoc String: ~
  -InitialReplicationStartTime,-IRTime DateTime: ~
  -Passthru Switch: ~
  -UseBackup Switch: ~
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
