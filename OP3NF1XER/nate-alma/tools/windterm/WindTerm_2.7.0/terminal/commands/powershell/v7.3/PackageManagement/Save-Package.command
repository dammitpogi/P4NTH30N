description: Saves packages to the local computer without installing them
synopses:
- Save-Package [-Name] <String[]> [-RequiredVersion <String>] [-MinimumVersion <String>]
  [-MaximumVersion <String>] [-Source <String[]>] [-Path <String>] [-LiteralPath <String>]
  [-Credential <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions]
  [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [-ProviderName <String[]>] [<CommonParameters>]
- Save-Package [-Path <String>] [-LiteralPath <String>] -InputObject <SoftwareIdentity>
  [-Credential <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions]
  [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm] [<CommonParameters>]
- Save-Package [-Path <String>] [-LiteralPath <String>] [-Credential <PSCredential>]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-ConfigFile <String>] [-SkipValidate] [-Headers <String[]>]
  [-FilterOnTag <String[]>] [-Contains <String>] [-AllowPrereleaseVersions] [<CommonParameters>]
- Save-Package [-Path <String>] [-LiteralPath <String>] [-Credential <PSCredential>]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-ConfigFile <String>] [-SkipValidate] [-Headers <String[]>]
  [-FilterOnTag <String[]>] [-Contains <String>] [-AllowPrereleaseVersions] [<CommonParameters>]
- Save-Package [-Path <String>] [-LiteralPath <String>] [-Credential <PSCredential>]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-AllowPrereleaseVersions] [-PackageManagementProvider <String>]
  [-PublishLocation <String>] [-ScriptSourceLocation <String>] [-ScriptPublishLocation
  <String>] [-Type <String>] [-Filter <String>] [-Tag <String[]>] [-Includes <String[]>]
  [-DscResource <String[]>] [-RoleCapability <String[]>] [-Command <String[]>] [-AcceptLicense]
  [<CommonParameters>]
- Save-Package [-Path <String>] [-LiteralPath <String>] [-Credential <PSCredential>]
  [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [-AllowPrereleaseVersions] [-PackageManagementProvider <String>]
  [-PublishLocation <String>] [-ScriptSourceLocation <String>] [-ScriptPublishLocation
  <String>] [-Type <String>] [-Filter <String>] [-Tag <String[]>] [-Includes <String[]>]
  [-DscResource <String[]>] [-RoleCapability <String[]>] [-Command <String[]>] [-AcceptLicense]
  [<CommonParameters>]
options:
  -AcceptLicense Switch: ~
  -AllowPrereleaseVersions Switch: ~
  -AllVersions Switch: ~
  -Command System.String[]: ~
  -ConfigFile System.String: ~
  -Contains System.String: ~
  -Credential System.Management.Automation.PSCredential: ~
  -DscResource System.String[]: ~
  -Filter System.String: ~
  -FilterOnTag System.String[]: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
  -Headers System.String[]: ~
  -Includes System.String[]:
    values:
    - DscResource
    - Cmdlet
    - Function
    - Workflow
    - RoleCapability
  -InputObject Microsoft.PackageManagement.Packaging.SoftwareIdentity:
    required: true
  -LiteralPath System.String: ~
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]:
    required: true
  -PackageManagementProvider System.String: ~
  -Path System.String: ~
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
  -ScriptPublishLocation System.String: ~
  -ScriptSourceLocation System.String: ~
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
