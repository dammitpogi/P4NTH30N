description: Gets one or more Active Directory domain controllers based on discoverable
  services criteria, search parameters or by providing a domain controller identifier,
  such as the NetBIOS name
synopses:
- Get-ADDomainController [-AuthType <ADAuthType>] [-Credential <PSCredential>] [[-Identity]
  <ADDomainController>] [-Server <String>] [<CommonParameters>]
- Get-ADDomainController [-AuthType <ADAuthType>] [-AvoidSelf] [-Discover] [-DomainName
  <String>] [-ForceDiscover] [-MinimumDirectoryServiceVersion <ADMinimumDirectoryServiceVersion>]
  [-NextClosestSite] [-Service <ADDiscoverableService[]>] [-SiteName <String>] [-Writable]
  [<CommonParameters>]
- Get-ADDomainController [-AuthType <ADAuthType>] [-Credential <PSCredential>] -Filter
  <String> [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -AvoidSelf Switch: ~
  -Credential PSCredential: ~
  -Discover Switch:
    required: true
  -DomainName String: ~
  -Filter String:
    required: true
  -ForceDiscover Switch: ~
  -Identity ADDomainController: ~
  -MinimumDirectoryServiceVersion ADMinimumDirectoryServiceVersion:
    values:
    - Windows2000
    - Windows2008
    - Windows2012
    - Windows2012R2
  -NextClosestSite Switch: ~
  -Server String: ~
  -Service ADDiscoverableService[]:
    values:
    - PrimaryDC
    - GlobalCatalog
    - KDC
    - TimeService
    - ReliableTimeService
    - ADWS
  -SiteName String: ~
  -Writable Switch: ~
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
