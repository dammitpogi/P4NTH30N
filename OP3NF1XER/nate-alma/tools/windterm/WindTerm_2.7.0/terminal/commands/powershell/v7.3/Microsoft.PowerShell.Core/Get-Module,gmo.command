description: List the modules imported in the current session or that can be imported
  from the PSModulePath
synopses:
- Get-Module [[-Name] <String[]>] [-FullyQualifiedName <ModuleSpecification[]>] [-All]
  [<CommonParameters>]
- Get-Module [[-Name] <String[]>] [-FullyQualifiedName <ModuleSpecification[]>] [-All]
  [-ListAvailable] [-PSEdition <String>] [-SkipEditionCheck] [-Refresh] [<CommonParameters>]
- Get-Module [[-Name] <String[]>] [-FullyQualifiedName <ModuleSpecification[]>] [-ListAvailable]
  [-PSEdition <String>] [-SkipEditionCheck] [-Refresh] -PSSession <PSSession> [<CommonParameters>]
- Get-Module [[-Name] <String[]>] [-FullyQualifiedName <ModuleSpecification[]>] [-ListAvailable]
  [-SkipEditionCheck] [-Refresh] -CimSession <CimSession> [-CimResourceUri <Uri>]
  [-CimNamespace <String>] [<CommonParameters>]
options:
  -All Switch: ~
  -CimNamespace System.String: ~
  -CimResourceUri System.Uri: ~
  -CimSession Microsoft.Management.Infrastructure.CimSession:
    required: true
  -FullyQualifiedName Microsoft.PowerShell.Commands.ModuleSpecification[]: ~
  -ListAvailable Switch: ~
  -Name System.String[]: ~
  -PSEdition System.String: ~
  -PSSession System.Management.Automation.Runspaces.PSSession:
    required: true
  -Refresh Switch: ~
  -SkipEditionCheck Switch: ~
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
