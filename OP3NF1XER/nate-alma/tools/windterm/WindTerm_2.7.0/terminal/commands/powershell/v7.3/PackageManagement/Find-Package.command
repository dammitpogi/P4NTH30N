description: Finds software packages in available package sources
synopses:
- Find-Package [-IncludeDependencies] [-AllVersions] [-Source <String[]>] [-Credential
  <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [[-Name] <String[]>]
  [-RequiredVersion <String>] [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-Force] [-ForceBootstrap] [-ProviderName <String[]>] [-ConfigFile <String>] [-SkipValidate]
  [-Headers <String[]>] [-FilterOnTag <String[]>] [-Contains <String>] [-AllowPrereleaseVersions]
  [<CommonParameters>]
- Find-Package [-IncludeDependencies] [-AllVersions] [-Source <String[]>] [-Credential
  <PSCredential>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [[-Name] <String[]>]
  [-RequiredVersion <String>] [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-Force] [-ForceBootstrap] [-ProviderName <String[]>] [-AllowPrereleaseVersions]
  [-PackageManagementProvider <String>] [-PublishLocation <String>] [-ScriptSourceLocation
  <String>] [-ScriptPublishLocation <String>] [-Type <String>] [-Filter <String>]
  [-Tag <String[]>] [-Includes <String[]>] [-DscResource <String[]>] [-RoleCapability
  <String[]>] [-Command <String[]>] [-AcceptLicense] [<CommonParameters>]
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
  -IncludeDependencies Switch: ~
  -Includes System.String[]:
    values:
    - Cmdlet
    - DscResource
    - Function
    - RoleCapability
    - Workflow
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]: ~
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
