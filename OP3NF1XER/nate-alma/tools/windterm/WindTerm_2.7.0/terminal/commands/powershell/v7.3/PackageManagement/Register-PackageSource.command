description: Adds a package source for a specified package provider
synopses:
- Register-PackageSource [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [[-Name]
  <String>] [[-Location] <String>] [-Credential <PSCredential>] [-Trusted] [-Force]
  [-ForceBootstrap] [-WhatIf] [-Confirm] [-ProviderName <String>] [<CommonParameters>]
- Register-PackageSource [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [[-Name]
  <String>] [[-Location] <String>] [-Credential <PSCredential>] [-Trusted] [-Force]
  [-ForceBootstrap] [-WhatIf] [-Confirm] [-ConfigFile <String>] [-SkipValidate] [<CommonParameters>]
- Register-PackageSource [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [[-Name]
  <String>] [[-Location] <String>] [-Credential <PSCredential>] [-Trusted] [-Force]
  [-ForceBootstrap] [-WhatIf] [-Confirm] [-PackageManagementProvider <String>] [-PublishLocation
  <String>] [-ScriptSourceLocation <String>] [-ScriptPublishLocation <String>] [<CommonParameters>]
options:
  -ConfigFile System.String: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
  -Location System.String: ~
  -Name System.String: ~
  -PackageManagementProvider System.String: ~
  -ProviderName,-Provider System.String:
    values:
    - Bootstrap
    - NuGet
    - PowerShellGet
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -PublishLocation System.String: ~
  -ScriptPublishLocation System.String: ~
  -ScriptSourceLocation System.String: ~
  -SkipValidate Switch: ~
  -Trusted Switch: ~
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
