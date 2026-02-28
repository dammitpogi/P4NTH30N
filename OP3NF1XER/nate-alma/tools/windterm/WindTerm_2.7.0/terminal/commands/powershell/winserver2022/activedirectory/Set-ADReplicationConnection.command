description: Sets properties on Active Directory replication connections
synopses:
- Set-ADReplicationConnection [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] [-Identity] <ADReplicationConnection>
  [-PassThru] [-Remove <Hashtable>] [-Replace <Hashtable>] [-ReplicateFromDirectoryServer
  <ADDirectoryServer>] [-ReplicationSchedule <ActiveDirectorySchedule>] [-Server <String>]
  [<CommonParameters>]
- Set-ADReplicationConnection [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Clear
  <String[]>] [-Credential <PSCredential>] -Instance <ADReplicationConnection> [-PassThru]
  [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Identity ADReplicationConnection:
    required: true
  -Instance ADReplicationConnection:
    required: true
  -PassThru Switch: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -ReplicateFromDirectoryServer ADDirectoryServer: ~
  -ReplicationSchedule ActiveDirectorySchedule: ~
  -Server String: ~
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
