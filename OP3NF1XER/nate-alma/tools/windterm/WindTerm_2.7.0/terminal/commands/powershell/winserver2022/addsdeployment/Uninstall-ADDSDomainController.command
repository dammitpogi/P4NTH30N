description: Uninstalls a domain controller in Active Directory
synopses:
- Uninstall-ADDSDomainController [-SkipPreChecks] [-LocalAdministratorPassword <SecureString>]
  [-Credential <PSCredential>] [-DemoteOperationMasterRole] [-DnsDelegationRemovalCredential
  <PSCredential>] [-IgnoreLastDCInDomainMismatch] [-IgnoreLastDnsServerForZone] [-LastDomainControllerInDomain]
  [-NoRebootOnCompletion] [-RemoveApplicationPartitions] [-RemoveDnsDelegation] [-RetainDCMetadata]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Uninstall-ADDSDomainController [-SkipPreChecks] [-LocalAdministratorPassword <SecureString>]
  [-Credential <PSCredential>] [-DemoteOperationMasterRole] [-ForceRemoval] [-NoRebootOnCompletion]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DemoteOperationMasterRole Switch: ~
  -DnsDelegationRemovalCredential PSCredential: ~
  -Force Switch: ~
  -ForceRemoval Switch:
    required: true
  -IgnoreLastDCInDomainMismatch Switch: ~
  -IgnoreLastDnsServerForZone Switch: ~
  -LastDomainControllerInDomain Switch: ~
  -LocalAdministratorPassword SecureString: ~
  -NoRebootOnCompletion Switch: ~
  -RemoveApplicationPartitions Switch: ~
  -RemoveDnsDelegation Switch: ~
  -RetainDCMetadata Switch: ~
  -SkipPreChecks Switch: ~
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
