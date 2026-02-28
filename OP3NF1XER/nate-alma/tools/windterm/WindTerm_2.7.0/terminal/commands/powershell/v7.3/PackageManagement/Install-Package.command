description: Installs one or more software packages
synopses:
- Install-Package [-Name] <String[]> [-RequiredVersion <String>] [-MinimumVersion
  <String>] [-MaximumVersion <String>] [-Source <String[]>] [-Credential <PSCredential>]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-ProviderName <String[]>] [<CommonParameters>]
- Install-Package [-InputObject] <SoftwareIdentity[]> [-Credential <PSCredential>]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-Package [-Credential <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>]
  [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [-ConfigFile <String>]
  [-SkipValidate] [-Headers <String[]>] [-FilterOnTag <String[]>] [-Contains <String>]
  [-AllowPrereleaseVersions] [-Destination <String>] [-ExcludeVersion] [-Scope <String>]
  [-SkipDependencies] [<CommonParameters>]
- Install-Package [-Credential <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>]
  [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [-ConfigFile <String>]
  [-SkipValidate] [-Headers <String[]>] [-FilterOnTag <String[]>] [-Contains <String>]
  [-AllowPrereleaseVersions] [-Destination <String>] [-ExcludeVersion] [-Scope <String>]
  [-SkipDependencies] [<CommonParameters>]
- Install-Package [-Credential <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>]
  [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [-AllowPrereleaseVersions]
  [-Scope <String>] [-PackageManagementProvider <String>] [-PublishLocation <String>]
  [-ScriptSourceLocation <String>] [-ScriptPublishLocation <String>] [-Type <String>]
  [-Filter <String>] [-Tag <String[]>] [-Includes <String[]>] [-DscResource <String[]>]
  [-RoleCapability <String[]>] [-Command <String[]>] [-AcceptLicense] [-AllowClobber]
  [-SkipPublisherCheck] [-InstallUpdate] [-NoPathUpdate] [<CommonParameters>]
- Install-Package [-Credential <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>]
  [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [-AllowPrereleaseVersions]
  [-Scope <String>] [-PackageManagementProvider <String>] [-PublishLocation <String>]
  [-ScriptSourceLocation <String>] [-ScriptPublishLocation <String>] [-Type <String>]
  [-Filter <String>] [-Tag <String[]>] [-Includes <String[]>] [-DscResource <String[]>]
  [-RoleCapability <String[]>] [-Command <String[]>] [-AcceptLicense] [-AllowClobber]
  [-SkipPublisherCheck] [-InstallUpdate] [-NoPathUpdate] [<CommonParameters>]
options:
  -AcceptLicense Switch: ~
  -AllowClobber Switch: ~
  -AllowPrereleaseVersions Switch: ~
  -AllVersions Switch: ~
  -Command System.String[]: ~
  -ConfigFile System.String: ~
  -Contains System.String: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Destination System.String: ~
  -DscResource System.String[]: ~
  -ExcludeVersion Switch: ~
  -Filter System.String: ~
  -FilterOnTag System.String[]: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
  -Headers System.String[]: ~
  -Includes System.String[]:
    values:
    - Cmdlet
    - DscResource
    - Function
    - RoleCapability
    - Workflow
  -InputObject Microsoft.PackageManagement.Packaging.SoftwareIdentity[]:
    required: true
  -InstallUpdate Switch: ~
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -NoPathUpdate Switch: ~
  -PackageManagementProvider System.String: ~
  -ProviderName,-Provider System.String[]:
    values:
    - Bootstrap
    - NuGet
    - PowerShellGet
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -PublishLocation System.String: ~
  -RequiredVersion System.String: ~
  -RoleCapability System.String[]: ~
  -Scope System.String:
    values:
    - CurrentUser
    - AllUsers
  -ScriptPublishLocation System.String: ~
  -ScriptSourceLocation System.String: ~
  -SkipDependencies Switch: ~
  -SkipPublisherCheck Switch: ~
  -SkipValidate Switch: ~
  -Source System.String[]: ~
  -Tag System.String[]: ~
  -Type System.String:
    values:
    - Module
    - Script
    - All
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
