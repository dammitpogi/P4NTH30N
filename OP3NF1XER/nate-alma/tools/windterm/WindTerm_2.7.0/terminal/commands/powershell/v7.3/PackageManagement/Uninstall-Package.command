description: Uninstalls one or more software packages
synopses:
- Uninstall-Package [-InputObject] <SoftwareIdentity[]> [-AllVersions] [-Force] [-ForceBootstrap]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Uninstall-Package [-Name] <String[]> [-RequiredVersion <String>] [-MinimumVersion
  <String>] [-MaximumVersion <String>] [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf]
  [-Confirm] [-ProviderName <String[]>] [<CommonParameters>]
- Uninstall-Package [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm]
  [-Destination <String>] [-ExcludeVersion] [-Scope <String>] [-SkipDependencies]
  [<CommonParameters>]
- Uninstall-Package [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm]
  [-Destination <String>] [-ExcludeVersion] [-Scope <String>] [-SkipDependencies]
  [<CommonParameters>]
- Uninstall-Package [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm]
  [-Scope <String>] [-PackageManagementProvider <String>] [-Type <String>] [-AllowClobber]
  [-SkipPublisherCheck] [-InstallUpdate] [-NoPathUpdate] [-AllowPrereleaseVersions]
  [<CommonParameters>]
- Uninstall-Package [-AllVersions] [-Force] [-ForceBootstrap] [-WhatIf] [-Confirm]
  [-Scope <String>] [-PackageManagementProvider <String>] [-Type <String>] [-AllowClobber]
  [-SkipPublisherCheck] [-InstallUpdate] [-NoPathUpdate] [-AllowPrereleaseVersions]
  [<CommonParameters>]
options:
  -AllowClobber Switch: ~
  -AllowPrereleaseVersions Switch: ~
  -AllVersions Switch: ~
  -Destination System.String: ~
  -ExcludeVersion Switch: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
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
  -RequiredVersion System.String: ~
  -Scope System.String:
    values:
    - CurrentUser
    - AllUsers
  -SkipDependencies Switch: ~
  -SkipPublisherCheck Switch: ~
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
