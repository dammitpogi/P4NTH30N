description: Runs the prerequisites for installing a new forest in Active Directory
synopses:
- Test-ADDSForestInstallation -DomainName <String> [-SafeModeAdministratorPassword
  <SecureString>] [-CreateDnsDelegation] [-DatabasePath <String>] [-DnsDelegationCredential
  <PSCredential>] [-NoDnsOnNetwork] [-DomainMode <DomainMode>] [-DomainNetbiosName
  <String>] [-ForestMode <ForestMode>] [-InstallDns] [-LogPath <String>] [-NoRebootOnCompletion]
  [-SkipAutoConfigureDns] [-SysvolPath <String>] [-Force] [<CommonParameters>]
options:
  -CreateDnsDelegation Switch: ~
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
  -DomainName String:
    required: true
  -DomainNetbiosName String: ~
  -Force Switch: ~
  -ForestMode ForestMode:
    values:
    - Win2008
    - Win2008R2
    - Win2012
    - Win2012R2
    - WinThreshold
    - Default
  -InstallDns Switch: ~
  -LogPath String: ~
  -NoDnsOnNetwork Switch: ~
  -NoRebootOnCompletion Switch: ~
  -SafeModeAdministratorPassword SecureString: ~
  -SkipAutoConfigureDns Switch: ~
  -SysvolPath String: ~
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
