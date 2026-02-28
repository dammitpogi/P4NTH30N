description: Sets the replication properties for an Active Directory site
synopses:
- Set-ADReplicationSite [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-AutomaticInterSiteTopologyGenerationEnabled <Boolean>] [-AutomaticTopologyGenerationEnabled
  <Boolean>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description <String>]
  [-Identity] <ADReplicationSite> [-InterSiteTopologyGenerator <ADDirectoryServer>]
  [-ManagedBy <ADPrincipal>] [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-RedundantServerTopologyEnabled <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>]
  [-ReplicationSchedule <ActiveDirectorySchedule>] [-ScheduleHashingEnabled <Boolean>]
  [-Server <String>] [-TopologyCleanupEnabled <Boolean>] [-TopologyDetectStaleEnabled
  <Boolean>] [-TopologyMinimumHopsEnabled <Boolean>] [-UniversalGroupCachingEnabled
  <Boolean>] [-UniversalGroupCachingRefreshSite <ADReplicationSite>] [-WindowsServer2000BridgeheadSelectionMethodEnabled
  <Boolean>] [-WindowsServer2000KCCISTGSelectionBehaviorEnabled <Boolean>] [-WindowsServer2003KCCBehaviorEnabled
  <Boolean>] [-WindowsServer2003KCCIgnoreScheduleEnabled <Boolean>] [-WindowsServer2003KCCSiteLinkBridgingEnabled
  <Boolean>] [<CommonParameters>]
- Set-ADReplicationSite [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADReplicationSite> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -AutomaticInterSiteTopologyGenerationEnabled Boolean: ~
  -AutomaticTopologyGenerationEnabled Boolean: ~
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Identity ADReplicationSite:
    required: true
  -Instance ADReplicationSite:
    required: true
  -InterSiteTopologyGenerator ADDirectoryServer: ~
  -ManagedBy ADPrincipal: ~
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -RedundantServerTopologyEnabled Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -ReplicationSchedule ActiveDirectorySchedule: ~
  -ScheduleHashingEnabled Boolean: ~
  -Server String: ~
  -TopologyCleanupEnabled Boolean: ~
  -TopologyDetectStaleEnabled Boolean: ~
  -TopologyMinimumHopsEnabled Boolean: ~
  -UniversalGroupCachingEnabled Boolean: ~
  -UniversalGroupCachingRefreshSite ADReplicationSite: ~
  -WhatIf,-wi Switch: ~
  -WindowsServer2000BridgeheadSelectionMethodEnabled Boolean: ~
  -WindowsServer2000KCCISTGSelectionBehaviorEnabled Boolean: ~
  -WindowsServer2003KCCBehaviorEnabled Boolean: ~
  -WindowsServer2003KCCIgnoreScheduleEnabled Boolean: ~
  -WindowsServer2003KCCSiteLinkBridgingEnabled Boolean: ~
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
