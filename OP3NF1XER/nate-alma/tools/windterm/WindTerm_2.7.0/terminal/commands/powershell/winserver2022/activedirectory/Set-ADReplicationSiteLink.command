description: Sets the properties for an Active Directory site link
synopses:
- Set-ADReplicationSiteLink [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Cost <Int32>] [-Credential <PSCredential>] [-Description <String>]
  [-Identity] <ADReplicationSiteLink> [-PassThru] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-ReplicationFrequencyInMinutes <Int32>] [-ReplicationSchedule <ActiveDirectorySchedule>]
  [-Server <String>] [-SitesIncluded <Hashtable>] [<CommonParameters>]
- Set-ADReplicationSiteLink [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Instance <ADReplicationSiteLink>] [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Cost Int32: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Identity ADReplicationSiteLink:
    required: true
  -Instance ADReplicationSiteLink: ~
  -PassThru Switch: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -ReplicationFrequencyInMinutes Int32: ~
  -ReplicationSchedule ActiveDirectorySchedule: ~
  -Server String: ~
  -SitesIncluded Hashtable: ~
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
