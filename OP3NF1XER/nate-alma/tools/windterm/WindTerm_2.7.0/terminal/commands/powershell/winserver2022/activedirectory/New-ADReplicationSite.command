description: Creates an Active Directory replication site in the directory
synopses:
- New-ADReplicationSite [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-AutomaticInterSiteTopologyGenerationEnabled
  <Boolean>] [-AutomaticTopologyGenerationEnabled <Boolean>] [-Credential <PSCredential>]
  [-Description <String>] [-Instance <ADReplicationSite>] [-InterSiteTopologyGenerator
  <ADDirectoryServer>] [-ManagedBy <ADPrincipal>] [-Name] <String> [-OtherAttributes
  <Hashtable>] [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-RedundantServerTopologyEnabled
  <Boolean>] [-ReplicationSchedule <ActiveDirectorySchedule>] [-ScheduleHashingEnabled
  <Boolean>] [-Server <String>] [-TopologyCleanupEnabled <Boolean>] [-TopologyDetectStaleEnabled
  <Boolean>] [-TopologyMinimumHopsEnabled <Boolean>] [-UniversalGroupCachingEnabled
  <Boolean>] [-UniversalGroupCachingRefreshSite <ADReplicationSite>] [-WindowsServer2000BridgeheadSelectionMethodEnabled
  <Boolean>] [-WindowsServer2000KCCISTGSelectionBehaviorEnabled <Boolean>] [-WindowsServer2003KCCBehaviorEnabled
  <Boolean>] [-WindowsServer2003KCCIgnoreScheduleEnabled <Boolean>] [-WindowsServer2003KCCSiteLinkBridgingEnabled
  <Boolean>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -AutomaticInterSiteTopologyGenerationEnabled Boolean: ~
  -AutomaticTopologyGenerationEnabled Boolean: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Instance ADReplicationSite: ~
  -InterSiteTopologyGenerator ADDirectoryServer: ~
  -ManagedBy ADPrincipal: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -RedundantServerTopologyEnabled Boolean: ~
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
