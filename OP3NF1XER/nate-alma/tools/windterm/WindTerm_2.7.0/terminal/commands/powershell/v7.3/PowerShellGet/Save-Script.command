description: Saves a script
synopses:
- Save-Script [-Name] <String[]> [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-RequiredVersion <String>] [-Repository <String[]>] [-Path] <String> [-Proxy <Uri>]
  [-ProxyCredential <PSCredential>] [-Credential <PSCredential>] [-Force] [-AllowPrerelease]
  [-AcceptLicense] [-WhatIf] [-Confirm] [<CommonParameters>]
- Save-Script [-Name] <String[]> [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-RequiredVersion <String>] [-Repository <String[]>] -LiteralPath <String> [-Proxy
  <Uri>] [-ProxyCredential <PSCredential>] [-Credential <PSCredential>] [-Force] [-AllowPrerelease]
  [-AcceptLicense] [-WhatIf] [-Confirm] [<CommonParameters>]
- Save-Script [-InputObject] <PSObject[]> -LiteralPath <String> [-Proxy <Uri>] [-ProxyCredential
  <PSCredential>] [-Credential <PSCredential>] [-Force] [-AcceptLicense] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Save-Script [-InputObject] <PSObject[]> [-Path] <String> [-Proxy <Uri>] [-ProxyCredential
  <PSCredential>] [-Credential <PSCredential>] [-Force] [-AcceptLicense] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AcceptLicense Switch: ~
  -AllowPrerelease Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject[]:
    required: true
  -LiteralPath,-PSPath System.String:
    required: true
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -Path System.String:
    required: true
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -Repository System.String[]: ~
  -RequiredVersion System.String: ~
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
