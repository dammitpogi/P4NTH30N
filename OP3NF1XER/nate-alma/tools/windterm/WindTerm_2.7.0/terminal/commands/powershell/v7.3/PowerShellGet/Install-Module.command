description: Downloads one or more modules from a repository, and installs them on
  the local computer
synopses:
- Install-Module [-Name] <String[]> [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-RequiredVersion <String>] [-Repository <String[]>] [-Credential <PSCredential>]
  [-Scope <String>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllowClobber]
  [-SkipPublisherCheck] [-Force] [-AllowPrerelease] [-AcceptLicense] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Install-Module [-InputObject] <PSObject[]> [-Credential <PSCredential>] [-Scope
  <String>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllowClobber] [-SkipPublisherCheck]
  [-Force] [-AcceptLicense] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptLicense Switch: ~
  -AllowClobber Switch: ~
  -AllowPrerelease Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject[]:
    required: true
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -PassThru Switch: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -Repository System.String[]: ~
  -RequiredVersion System.String: ~
  -Scope System.String:
    values:
    - CurrentUser
    - AllUsers
  -SkipPublisherCheck Switch: ~
  -Confirm,-cf Switch: ~
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
