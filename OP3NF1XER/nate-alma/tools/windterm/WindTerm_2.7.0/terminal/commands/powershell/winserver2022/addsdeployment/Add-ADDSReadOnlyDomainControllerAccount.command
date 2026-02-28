description: Creates a RODC account that can be used to install an RODC in Active
  Directory
synopses:
- Add-ADDSReadOnlyDomainControllerAccount [-SkipPreChecks] -DomainControllerAccountName
  <String> -DomainName <String> -SiteName <String> [-AllowPasswordReplicationAccountName
  <String[]>] [-Credential <PSCredential>] [-DelegatedAdministratorAccountName <String>]
  [-DenyPasswordReplicationAccountName <String[]>] [-NoGlobalCatalog] [-InstallDns]
  [-ReplicationSourceDC <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowPasswordReplicationAccountName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DelegatedAdministratorAccountName String: ~
  -DenyPasswordReplicationAccountName String[]: ~
  -DomainControllerAccountName String:
    required: true
  -DomainName String:
    required: true
  -Force Switch: ~
  -InstallDns Switch: ~
  -NoGlobalCatalog Switch: ~
  -ReplicationSourceDC String: ~
  -SiteName String:
    required: true
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
