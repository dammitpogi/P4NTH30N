description: Downloads and installs the newest version of specified modules from an
  online gallery to the local computer
synopses:
- Update-Module [[-Name] <String[]>] [-RequiredVersion <String>] [-MaximumVersion
  <String>] [-Credential <PSCredential>] [-Scope <String>] [-Proxy <Uri>] [-ProxyCredential
  <PSCredential>] [-Force] [-AllowPrerelease] [-AcceptLicense] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AcceptLicense Switch: ~
  -AllowPrerelease Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -MaximumVersion System.String: ~
  -Name System.String[]: ~
  -PassThru Switch: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
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
