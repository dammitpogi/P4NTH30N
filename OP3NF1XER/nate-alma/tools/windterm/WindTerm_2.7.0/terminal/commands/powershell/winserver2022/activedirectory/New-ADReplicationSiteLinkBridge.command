description: Creates a site link bridge in Active Directory for replication
synopses:
- New-ADReplicationSiteLinkBridge [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Description <String>] [-Instance <ADReplicationSiteLinkBridge>]
  [-InterSiteTransportProtocol <ADInterSiteTransportProtocolType>] [-Name] <String>
  [-OtherAttributes <Hashtable>] [-PassThru] [-Server <String>] [[-SiteLinksIncluded]
  <ADReplicationSiteLink[]>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Instance ADReplicationSiteLinkBridge: ~
  -InterSiteTransportProtocol ADInterSiteTransportProtocolType:
    values:
    - IP
    - SMTP
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -Server String: ~
  -SiteLinksIncluded ADReplicationSiteLink[]: ~
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
