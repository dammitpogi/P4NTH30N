description: Downloads and saves the newest help files to a file system directory
synopses:
- Save-Help [-DestinationPath] <String[]> [[-Module] <PSModuleInfo[]>] [-FullyQualifiedModule
  <ModuleSpecification[]>] [[-UICulture] <CultureInfo[]>] [-Credential <PSCredential>]
  [-UseDefaultCredentials] [-Force] [-Scope <UpdateHelpScope>] [<CommonParameters>]
- Save-Help -LiteralPath <String[]> [[-Module] <PSModuleInfo[]>] [-FullyQualifiedModule
  <ModuleSpecification[]>] [[-UICulture] <CultureInfo[]>] [-Credential <PSCredential>]
  [-UseDefaultCredentials] [-Force] [-Scope <UpdateHelpScope>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -DestinationPath,-Path System.String[]:
    required: true
  -Force Switch: ~
  -FullyQualifiedModule Microsoft.PowerShell.Commands.ModuleSpecification[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Module,-Name System.Management.Automation.PSModuleInfo[]: ~
  -Scope Microsoft.PowerShell.Commands.UpdateHelpScope: ~
  -UICulture System.Globalization.CultureInfo[]: ~
  -UseDefaultCredentials Switch: ~
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
