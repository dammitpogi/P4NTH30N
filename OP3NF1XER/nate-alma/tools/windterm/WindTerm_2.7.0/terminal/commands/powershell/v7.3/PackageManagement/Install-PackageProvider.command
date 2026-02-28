description: Installs one or more Package Management package providers
synopses:
- Install-PackageProvider [-Name] <String[]> [-RequiredVersion <String>] [-MinimumVersion
  <String>] [-MaximumVersion <String>] [-Credential <PSCredential>] [-Scope <String>]
  [-Source <String[]>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions]
  [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-PackageProvider [-Scope <String>] [-InputObject] <SoftwareIdentity[]> [-Proxy
  <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllVersions Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
  -InputObject Microsoft.PackageManagement.Packaging.SoftwareIdentity[]:
    required: true
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -RequiredVersion System.String: ~
  -Scope System.String:
    values:
    - CurrentUser
    - AllUsers
  -Source System.String[]: ~
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
