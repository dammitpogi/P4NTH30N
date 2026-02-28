description: Creates a new module manifest
synopses:
- New-ModuleManifest [-Path] <String> [-NestedModules <Object[]>] [-Guid <Guid>] [-Author
  <String>] [-CompanyName <String>] [-Copyright <String>] [-RootModule <String>] [-ModuleVersion
  <Version>] [-Description <String>] [-ProcessorArchitecture <ProcessorArchitecture>]
  [-PowerShellVersion <Version>] [-CLRVersion <Version>] [-DotNetFrameworkVersion
  <Version>] [-PowerShellHostName <String>] [-PowerShellHostVersion <Version>] [-RequiredModules
  <Object[]>] [-TypesToProcess <String[]>] [-FormatsToProcess <String[]>] [-ScriptsToProcess
  <String[]>] [-RequiredAssemblies <String[]>] [-FileList <String[]>] [-ModuleList
  <Object[]>] [-FunctionsToExport <String[]>] [-AliasesToExport <String[]>] [-VariablesToExport
  <String[]>] [-CmdletsToExport <String[]>] [-DscResourcesToExport <String[]>] [-CompatiblePSEditions
  <String[]>] [-PrivateData <Object>] [-Tags <String[]>] [-ProjectUri <Uri>] [-LicenseUri
  <Uri>] [-IconUri <Uri>] [-ReleaseNotes <String>] [-Prerelease <String>] [-RequireLicenseAcceptance]
  [-ExternalModuleDependencies <String[]>] [-HelpInfoUri <String>] [-PassThru] [-DefaultCommandPrefix
  <String>] [-WhatIf] [-Confirm]  [<CommonParameters>]
options:
  -AliasesToExport System.String[]: ~
  -Author System.String: ~
  -ClrVersion System.Version: ~
  -CmdletsToExport System.String[]: ~
  -CompanyName System.String: ~
  -CompatiblePSEditions System.String[]:
    values:
    - Desktop
    - Core
  -Copyright System.String: ~
  -DefaultCommandPrefix System.String: ~
  -Description System.String: ~
  -DotNetFrameworkVersion System.Version: ~
  -DscResourcesToExport System.String[]: ~
  -ExternalModuleDependencies System.String[]: ~
  -FileList System.String[]: ~
  -FormatsToProcess System.String[]: ~
  -FunctionsToExport System.String[]: ~
  -Guid System.Guid: ~
  -HelpInfoUri System.String: ~
  -IconUri System.Uri: ~
  -LicenseUri System.Uri: ~
  -ModuleList System.Object[]: ~
  -ModuleVersion System.Version: ~
  -NestedModules System.Object[]: ~
  -PassThru Switch: ~
  -Path System.String:
    required: true
  -PowerShellHostName System.String: ~
  -PowerShellHostVersion System.Version: ~
  -PowerShellVersion System.Version: ~
  -Prerelease System.String: ~
  -PrivateData System.Object: ~
  -ProcessorArchitecture System.Reflection.ProcessorArchitecture:
    values:
    - None
    - MSIL
    - X86
    - IA64
    - Amd64
    - Arm
  -ProjectUri System.Uri: ~
  -ReleaseNotes System.String: ~
  -RequiredAssemblies System.String[]: ~
  -RequiredModules System.Object[]: ~
  -RequireLicenseAcceptance Switch: ~
  -RootModule,-ModuleToProcess System.String: ~
  -ScriptsToProcess System.String[]: ~
  -Tags System.String[]: ~
  -TypesToProcess System.String[]: ~
  -VariablesToExport System.String[]: ~
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
