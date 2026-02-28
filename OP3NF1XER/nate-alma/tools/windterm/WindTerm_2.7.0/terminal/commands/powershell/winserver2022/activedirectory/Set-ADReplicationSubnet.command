description: Sets the properties of an Active Directory replication subnet object
synopses:
- Set-ADReplicationSubnet [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] [-Description <String>] [-Identity]
  <ADReplicationSubnet> [-Location <String>] [-PassThru] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-Server <String>] [-Site <ADReplicationSite>] [<CommonParameters>]
- Set-ADReplicationSubnet [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Instance <ADReplicationSubnet>] [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Identity ADReplicationSubnet:
    required: true
  -Instance ADReplicationSubnet: ~
  -Location String: ~
  -PassThru Switch: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -Server String: ~
  -Site ADReplicationSite: ~
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
