description: Sets the properties of a replication site link bridge in Active Directory
synopses:
- Set-ADReplicationSiteLinkBridge [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType
  <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description <String>]
  [-Identity] <ADReplicationSiteLinkBridge> [-PassThru] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-Server <String>] [-SiteLinksIncluded <Hashtable>] [<CommonParameters>]
- Set-ADReplicationSiteLinkBridge [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Instance <ADReplicationSiteLinkBridge>] [-PassThru] [-Server <String>]
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
  -Identity ADReplicationSiteLinkBridge:
    required: true
  -Instance ADReplicationSiteLinkBridge: ~
  -PassThru Switch: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -Server String: ~
  -SiteLinksIncluded Hashtable: ~
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
