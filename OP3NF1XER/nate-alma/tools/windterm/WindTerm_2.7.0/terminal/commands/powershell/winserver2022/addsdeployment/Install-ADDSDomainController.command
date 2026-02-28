description: Installs a new domain controller in an Active Directory domain
synopses:
- Install-ADDSDomainController [-SkipPreChecks] -DomainName <String> [-SafeModeAdministratorPassword
  <SecureString>] [-SiteName <String>] [-ADPrepCredential <PSCredential>] [-AllowDomainControllerReinstall]
  [-ApplicationPartitionsToReplicate <String[]>] [-CreateDnsDelegation] [-Credential
  <PSCredential>] [-CriticalReplicationOnly] [-DatabasePath <String>] [-DnsDelegationCredential
  <PSCredential>] [-NoDnsOnNetwork] [-NoGlobalCatalog] [-InstallationMediaPath <String>]
  [-InstallDns] [-LogPath <String>] [-MoveInfrastructureOperationMasterRoleIfNecessary]
  [-NoRebootOnCompletion] [-ReplicationSourceDC <String>] [-SkipAutoConfigureDns]
  [-SystemKey <SecureString>] [-SysvolPath <String>] [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Install-ADDSDomainController [-SkipPreChecks] -DomainName <String> [-SafeModeAdministratorPassword
  <SecureString>] -SiteName <String> [-ADPrepCredential <PSCredential>] [-AllowDomainControllerReinstall]
  [-AllowPasswordReplicationAccountName <String[]>] [-ApplicationPartitionsToReplicate
  <String[]>] [-Credential <PSCredential>] [-CriticalReplicationOnly] [-DatabasePath
  <String>] [-DelegatedAdministratorAccountName <String>] [-DenyPasswordReplicationAccountName
  <String[]>] [-NoDnsOnNetwork] [-NoGlobalCatalog] [-InstallationMediaPath <String>]
  [-InstallDns] [-LogPath <String>] [-MoveInfrastructureOperationMasterRoleIfNecessary]
  [-ReadOnlyReplica] [-NoRebootOnCompletion] [-ReplicationSourceDC <String>] [-SkipAutoConfigureDns]
  [-SystemKey <SecureString>] [-SysvolPath <String>] [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Install-ADDSDomainController [-SkipPreChecks] -DomainName <String> [-SafeModeAdministratorPassword
  <SecureString>] [-ADPrepCredential <PSCredential>] [-ApplicationPartitionsToReplicate
  <String[]>] [-Credential <PSCredential>] [-CriticalReplicationOnly] [-DatabasePath
  <String>] [-NoDnsOnNetwork] [-InstallationMediaPath <String>] [-LogPath <String>]
  [-NoRebootOnCompletion] [-ReplicationSourceDC <String>] [-SkipAutoConfigureDns]
  [-SystemKey <SecureString>] [-SysvolPath <String>] [-UseExistingAccount] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADPrepCredential PSCredential: ~
  -AllowDomainControllerReinstall Switch: ~
  -AllowPasswordReplicationAccountName String[]: ~
  -ApplicationPartitionsToReplicate String[]: ~
  -Confirm,-cf Switch: ~
  -CreateDnsDelegation Switch: ~
  -Credential PSCredential: ~
  -CriticalReplicationOnly Switch: ~
  -DatabasePath String: ~
  -DelegatedAdministratorAccountName String: ~
  -DenyPasswordReplicationAccountName String[]: ~
  -DnsDelegationCredential PSCredential: ~
  -DomainName String:
    required: true
  -Force Switch: ~
  -InstallDns Switch: ~
  -InstallationMediaPath String: ~
  -LogPath String: ~
  -MoveInfrastructureOperationMasterRoleIfNecessary Switch: ~
  -NoDnsOnNetwork Switch: ~
  -NoGlobalCatalog Switch: ~
  -NoRebootOnCompletion Switch: ~
  -ReadOnlyReplica Switch: ~
  -ReplicationSourceDC String: ~
  -SafeModeAdministratorPassword SecureString: ~
  -SiteName String: ~
  -SkipAutoConfigureDns Switch: ~
  -SkipPreChecks Switch: ~
  -SystemKey SecureString: ~
  -SysvolPath String: ~
  -UseExistingAccount Switch: ~
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
