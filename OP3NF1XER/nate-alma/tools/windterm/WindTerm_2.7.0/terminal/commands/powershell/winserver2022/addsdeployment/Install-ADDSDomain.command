description: Creates a new domain in an existing Active Directory forest
synopses:
- Install-ADDSDomain [-SkipPreChecks] -NewDomainName <String> -ParentDomainName <String>
  [-SafeModeAdministratorPassword <SecureString>] [-ADPrepCredential <PSCredential>]
  [-AllowDomainReinstall] [-CreateDnsDelegation] [-Credential <PSCredential>] [-DatabasePath
  <String>] [-DnsDelegationCredential <PSCredential>] [-NoDnsOnNetwork] [-DomainMode
  <DomainMode>] [-DomainType <DomainType>] [-NoGlobalCatalog] [-InstallDns] [-LogPath
  <String>] [-NewDomainNetbiosName <String>] [-NoRebootOnCompletion] [-ReplicationSourceDC
  <String>] [-SiteName <String>] [-SkipAutoConfigureDns] [-SysvolPath <String>] [-Force]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADPrepCredential PSCredential: ~
  -AllowDomainReinstall Switch: ~
  -Confirm,-cf Switch: ~
  -CreateDnsDelegation Switch: ~
  -Credential PSCredential: ~
  -DatabasePath String: ~
  -DnsDelegationCredential PSCredential: ~
  -DomainMode DomainMode:
    values:
    - Win2008
    - Win2008R2
    - Win2012
    - Win2012R2
    - WinThreshold
    - Default
  -DomainType DomainType:
    values:
    - ChildDomain
    - TreeDomain
  -Force Switch: ~
  -InstallDns Switch: ~
  -LogPath String: ~
  -NewDomainName String:
    required: true
  -NewDomainNetbiosName String: ~
  -NoDnsOnNetwork Switch: ~
  -NoGlobalCatalog Switch: ~
  -NoRebootOnCompletion Switch: ~
  -ParentDomainName String:
    required: true
  -ReplicationSourceDC String: ~
  -SafeModeAdministratorPassword SecureString: ~
  -SiteName String: ~
  -SkipAutoConfigureDns Switch: ~
  -SkipPreChecks Switch: ~
  -SysvolPath String: ~
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
