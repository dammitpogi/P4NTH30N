description: Adds modules to the current session
synopses:
- Import-Module [-Global] [-Prefix <String>] [-Name] <String[]> [-Function <String[]>]
  [-Cmdlet <String[]>] [-Variable <String[]>] [-Alias <String[]>] [-Force] [-SkipEditionCheck]
  [-PassThru] [-AsCustomObject] [-MinimumVersion <Version>] [-MaximumVersion <String>]
  [-RequiredVersion <Version>] [-ArgumentList <Object[]>] [-DisableNameChecking] [-NoClobber]
  [-Scope <String>]  [<CommonParameters>]
- Import-Module [-Global] [-Prefix <String>] [-Name] <String[]> [-Function <String[]>]
  [-Cmdlet <String[]>] [-Variable <String[]>] [-Alias <String[]>] [-Force] [-SkipEditionCheck]
  [-PassThru] [-AsCustomObject] [-MinimumVersion <Version>] [-MaximumVersion <String>]
  [-RequiredVersion <Version>] [-ArgumentList <Object[]>] [-DisableNameChecking] [-NoClobber]
  [-Scope <String>] -PSSession <PSSession>  [<CommonParameters>]
- Import-Module [-Global] [-Prefix <String>] [-Name] <String[]> [-Function <String[]>]
  [-Cmdlet <String[]>] [-Variable <String[]>] [-Alias <String[]>] [-Force] [-SkipEditionCheck]
  [-PassThru] [-AsCustomObject] [-MinimumVersion <Version>] [-MaximumVersion <String>]
  [-RequiredVersion <Version>] [-ArgumentList <Object[]>] [-DisableNameChecking] [-NoClobber]
  [-Scope <String>] -CimSession <CimSession> [-CimResourceUri <Uri>] [-CimNamespace
  <String>] [<CommonParameters>]
- Import-Module [-Name] <string[]> -UseWindowsPowerShell [-Global] [-Prefix <string>]
  [-Function <string[]>] [-Cmdlet <string[]>] [-Variable <string[]>] [-Alias <string[]>]
  [-Force] [-PassThru] [-AsCustomObject] [-MinimumVersion <version>] [-MaximumVersion
  <string>] [-RequiredVersion <version>] [-ArgumentList <Object[]>] [-DisableNameChecking]
  [-NoClobber] [-Scope <string>] [<CommonParameters>]
- Import-Module [-Global] [-Prefix <String>] [-FullyQualifiedName] <ModuleSpecification[]>
  [-Function <String[]>] [-Cmdlet <String[]>] [-Variable <String[]>] [-Alias <String[]>]
  [-Force] [-SkipEditionCheck] [-PassThru] [-AsCustomObject] [-ArgumentList <Object[]>]
  [-DisableNameChecking] [-NoClobber] [-Scope <String>]  [<CommonParameters>]
- Import-Module [-Global] [-Prefix <String>] [-FullyQualifiedName] <ModuleSpecification[]>
  [-Function <String[]>] [-Cmdlet <String[]>] [-Variable <String[]>] [-Alias <String[]>]
  [-Force] [-SkipEditionCheck] [-PassThru] [-AsCustomObject] [-ArgumentList <Object[]>]
  [-DisableNameChecking] [-NoClobber] [-Scope <String>] -PSSession <PSSession>  [<CommonParameters>]
- Import-Module [-FullyQualifiedName] <ModuleSpecification[]> -UseWindowsPowerShell
  [-Global] [-Prefix <string>] [-Function <string[]>] [-Cmdlet <string[]>] [-Variable
  <string[]>] [-Alias <string[]>] [-Force] [-PassThru] [-AsCustomObject] [-ArgumentList
  <Object[]>] [-DisableNameChecking] [-NoClobber] [-Scope <string>] [<CommonParameters>]
- Import-Module [-Global] [-Prefix <String>] [-Assembly] <Assembly[]> [-Function <String[]>]
  [-Cmdlet <String[]>] [-Variable <String[]>] [-Alias <String[]>] [-Force] [-SkipEditionCheck]
  [-PassThru] [-AsCustomObject] [-ArgumentList <Object[]>] [-DisableNameChecking]
  [-NoClobber] [-Scope <String>]  [<CommonParameters>]
- Import-Module [-Global] [-Prefix <String>] [-Function <String[]>] [-Cmdlet <String[]>]
  [-Variable <String[]>] [-Alias <String[]>] [-Force] [-SkipEditionCheck] [-PassThru]
  [-AsCustomObject] [-ModuleInfo] <PSModuleInfo[]> [-ArgumentList <Object[]>] [-DisableNameChecking]
  [-NoClobber] [-Scope <String>]  [<CommonParameters>]
options:
  -Alias System.String[]: ~
  -ArgumentList,-Args System.Object[]: ~
  -AsCustomObject Switch: ~
  -Assembly System.Reflection.Assembly[]:
    required: true
  -CimNamespace System.String: ~
  -CimResourceUri System.Uri: ~
  -CimSession Microsoft.Management.Infrastructure.CimSession:
    required: true
  -Cmdlet System.String[]: ~
  -DisableNameChecking Switch: ~
  -Force Switch: ~
  -FullyQualifiedName Microsoft.PowerShell.Commands.ModuleSpecification[]:
    required: true
  -Function System.String[]: ~
  -Global Switch: ~
  -MaximumVersion System.String: ~
  -MinimumVersion,-Version System.Version: ~
  -ModuleInfo System.Management.Automation.PSModuleInfo[]:
    required: true
  -Name System.String[]:
    required: true
  -NoClobber,-NoOverwrite Switch: ~
  -PassThru Switch: ~
  -Prefix System.String: ~
  -PSSession System.Management.Automation.Runspaces.PSSession:
    required: true
  -RequiredVersion System.Version: ~
  -Scope System.String:
    values:
    - Local
    - Global
  -SkipEditionCheck Switch: ~
  -UseWindowsPowerShell,-UseWinPS Switch:
    required: true
  -Variable System.String[]: ~
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
