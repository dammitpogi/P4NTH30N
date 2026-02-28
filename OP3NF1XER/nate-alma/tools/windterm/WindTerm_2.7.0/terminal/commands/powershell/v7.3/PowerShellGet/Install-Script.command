description: Installs a script
synopses:
- Install-Script [-Name] <String[]> [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-RequiredVersion <String>] [-Repository <String[]>] [-Scope <String>] [-NoPathUpdate]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-Credential <PSCredential>] [-Force]
  [-AllowPrerelease] [-AcceptLicense] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-Script [-InputObject] <PSObject[]> [-Scope <String>] [-NoPathUpdate] [-Proxy
  <Uri>] [-ProxyCredential <PSCredential>] [-Credential <PSCredential>] [-Force] [-AcceptLicense]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptLicense Switch: ~
  -AllowPrerelease Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject[]:
    required: true
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -NoPathUpdate Switch: ~
  -PassThru Switch: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -Repository System.String[]: ~
  -RequiredVersion System.String: ~
  -Scope System.String:
    values:
    - CurrentUser
    - AllUsers
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
