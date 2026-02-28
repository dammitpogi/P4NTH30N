description: Gets a list of package sources that are registered for a package provider
synopses:
- Get-PackageSource [[-Name] <String>] [-Location <String>] [-Force] [-ForceBootstrap]
  [-ProviderName <String[]>] [-ConfigFile <String>] [-SkipValidate] [<CommonParameters>]
- Get-PackageSource [[-Name] <String>] [-Location <String>] [-Force] [-ForceBootstrap]
  [-ProviderName <String[]>] [-PackageManagementProvider <String>] [-PublishLocation
  <String>] [-ScriptSourceLocation <String>] [-ScriptPublishLocation <String>] [<CommonParameters>]
options:
  -ConfigFile System.String: ~
  -Force Switch: ~
  -ForceBootstrap Switch: ~
  -Location System.String: ~
  -Name System.String: ~
  -PackageManagementProvider System.String: ~
  -ProviderName,-Provider System.String[]:
    values:
    - Bootstrap
    - NuGet
    - PowerShellGet
  -PublishLocation System.String: ~
  -ScriptPublishLocation System.String: ~
  -ScriptSourceLocation System.String: ~
  -SkipValidate Switch: ~
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
