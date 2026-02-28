description: Removes a registered package source
synopses:
- Unregister-PackageSource [[-Source] <String>] [-Location <String>] [-Credential
  <PSCredential>] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [-ProviderName <String>]
  [<CommonParameters>]
- Unregister-PackageSource -InputObject <PackageSource[]> [-Credential <PSCredential>]
  [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [<CommonParameters>]
- Unregister-PackageSource [-Credential <PSCredential>] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-ConfigFile <String>] [-SkipValidate] [<CommonParameters>]
- Unregister-PackageSource [-Credential <PSCredential>] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-ConfigFile <String>] [-SkipValidate] [<CommonParameters>]
- Unregister-PackageSource [-Credential <PSCredential>] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-PackageManagementProvider <String>] [-PublishLocation <String>]
  [-ScriptSourceLocation <String>] [-ScriptPublishLocation <String>] [<CommonParameters>]
- Unregister-PackageSource [-Credential <PSCredential>] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-PackageManagementProvider <String>] [-PublishLocation <String>]
  [-ScriptSourceLocation <String>] [-ScriptPublishLocation <String>] [<CommonParameters>]
options:
  -ConfigFile System.String: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
  -InputObject Microsoft.PackageManagement.Packaging.PackageSource[]:
    required: true
  -Location System.String: ~
  -PackageManagementProvider System.String: ~
  -ProviderName,-Provider System.String:
    values:
    - Bootstrap
    - NuGet
    - PowerShellGet
  -PublishLocation System.String: ~
  -ScriptPublishLocation System.String: ~
  -ScriptSourceLocation System.String: ~
  -SkipValidate Switch: ~
  -Source,-Name System.String: ~
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
