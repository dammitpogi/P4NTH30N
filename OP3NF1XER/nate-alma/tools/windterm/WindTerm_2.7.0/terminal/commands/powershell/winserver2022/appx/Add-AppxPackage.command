description: Adds a signed app package to a user account
synopses:
- Add-AppxPackage [-Path] <String> [-DependencyPath <String[]>] [-RequiredContentGroupOnly]
  [-ForceApplicationShutdown] [-ForceTargetApplicationShutdown] [-ForceUpdateFromAnyVersion]
  [-RetainFilesOnFailure] [-InstallAllResources] [-Volume <AppxVolume>] [-ExternalPackages
  <String[]>] [-OptionalPackages <String[]>] [-RelatedPackages <String[]>] [-ExternalLocation
  <String>] [-DeferRegistrationWhenPackagesAreInUse]  [-StubPackageOption <StubPackageOption>]
  [-AllowUnsigned] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AppxPackage [-Path] <String> [-RequiredContentGroupOnly] [-AppInstallerFile]
  [-ForceTargetApplicationShutdown] [-InstallAllResources] [-LimitToExistingPackages]
  [-Volume <AppxVolume>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AppxPackage [-Path] <String> [-DependencyPath <String[]>] [-Register] [-DisableDevelopmentMode]
  [-ForceApplicationShutdown] [-ForceTargetApplicationShutdown] [-ForceUpdateFromAnyVersion]
  [-InstallAllResources] [-ExternalLocation <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AppxPackage [-Path] <String> [-DependencyPath <String[]>] [-RequiredContentGroupOnly]
  [-ForceApplicationShutdown] [-ForceTargetApplicationShutdown] [-ForceUpdateFromAnyVersion]
  [-RetainFilesOnFailure] [-InstallAllResources] [-Update] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AppxPackage [-Path] <String> [-DependencyPath <String[]>] [-RequiredContentGroupOnly]
  [-Stage] [-ForceUpdateFromAnyVersion] [-Volume <AppxVolume>] [-ExternalPackages
  <String[]>] [-OptionalPackages <String[]>] [-RelatedPackages <String[]>] [-ExternalLocation
  <String>] [-StubPackageOption <StubPackageOption>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AppxPackage [-Register] -MainPackage <String> [-DependencyPackages <String[]>]
  [-ForceApplicationShutdown] [-ForceTargetApplicationShutdown] [-ForceUpdateFromAnyVersion]
  [-InstallAllResources] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AppxPackage [-RegisterByFamilyName] -MainPackage <String> [-DependencyPackages
  <String[]>] [-ForceApplicationShutdown] [-ForceTargetApplicationShutdown] [-InstallAllResources]
  [-OptionalPackages <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowUnsigned Switch: ~
  -AppInstallerFile Switch:
    required: true
  -DeferRegistrationWhenPackagesAreInUse Switch: ~
  -DependencyPackages String[]: ~
  -DependencyPath String[]: ~
  -DisableDevelopmentMode Switch: ~
  -ExternalLocation String: ~
  -ExternalPackages String[]: ~
  -ForceApplicationShutdown Switch: ~
  -ForceTargetApplicationShutdown Switch: ~
  -ForceUpdateFromAnyVersion Switch: ~
  -InstallAllResources Switch: ~
  -LimitToExistingPackages Switch: ~
  -MainPackage String:
    required: true
  -OptionalPackages String[]: ~
  -Path,-PSPath String:
    required: true
  -Register Switch:
    required: true
  -RegisterByFamilyName Switch:
    required: true
  -RelatedPackages String[]: ~
  -RequiredContentGroupOnly Switch: ~
  -RetainFilesOnFailure Switch: ~
  -Stage Switch:
    required: true
  -StubPackageOption StubPackageOption: ~
  -Update Switch:
    required: true
  -Volume AppxVolume: ~
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
