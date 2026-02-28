description: Suspends replication of a virtual machine
synopses:
- Suspend-VMReplication [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-ReplicationRelationshipType <VMReplicationRelationshipType>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Suspend-VMReplication [-VM] <VirtualMachine[]> [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Suspend-VMReplication [-VMReplication] <VMReplication[]> [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -ReplicationRelationshipType,-Relationship VMReplicationRelationshipType:
    values:
    - Simple
    - Extended
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
