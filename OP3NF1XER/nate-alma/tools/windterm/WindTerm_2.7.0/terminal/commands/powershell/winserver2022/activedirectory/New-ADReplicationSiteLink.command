description: Creates a new Active Directory site link for in managing replication
synopses:
- New-ADReplicationSiteLink [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Cost <Int32>]
  [-Credential <PSCredential>] [-Description <String>] [-Instance <ADReplicationSiteLink>]
  [-InterSiteTransportProtocol <ADInterSiteTransportProtocolType>] [-Name] <String>
  [-OtherAttributes <Hashtable>] [-PassThru] [-ReplicationFrequencyInMinutes <Int32>]
  [-ReplicationSchedule <ActiveDirectorySchedule>] [-Server <String>] [[-SitesIncluded]
  <ADReplicationSite[]>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Cost Int32: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Instance ADReplicationSiteLink: ~
  -InterSiteTransportProtocol ADInterSiteTransportProtocolType:
    values:
    - IP
    - SMTP
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -ReplicationFrequencyInMinutes Int32: ~
  -ReplicationSchedule ActiveDirectorySchedule: ~
  -Server String: ~
  -SitesIncluded ADReplicationSite[]: ~
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
