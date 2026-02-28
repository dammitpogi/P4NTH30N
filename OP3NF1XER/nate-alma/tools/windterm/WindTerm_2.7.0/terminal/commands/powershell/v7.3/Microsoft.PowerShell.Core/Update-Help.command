description: Downloads and installs the newest help files on your computer
synopses:
- Update-Help [[-Module] <String[]>] [-FullyQualifiedModule <ModuleSpecification[]>]
  [[-SourcePath] <String[]>] [-Recurse] [[-UICulture] <CultureInfo[]>] [-Credential
  <PSCredential>] [-UseDefaultCredentials] [-Force] [-Scope <UpdateHelpScope>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Update-Help [[-Module] <String[]>] [-FullyQualifiedModule <ModuleSpecification[]>]
  [-LiteralPath <String[]>] [-Recurse] [[-UICulture] <CultureInfo[]>] [-Credential
  <PSCredential>] [-UseDefaultCredentials] [-Force] [-Scope <UpdateHelpScope>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -FullyQualifiedModule Microsoft.PowerShell.Commands.ModuleSpecification[]: ~
  -LiteralPath,-PSPath,-LP System.String[]: ~
  -Module,-Name System.String[]: ~
  -Recurse Switch: ~
  -Scope Microsoft.PowerShell.Commands.UpdateHelpScope: ~
  -SourcePath,-Path System.String[]: ~
  -UICulture System.Globalization.CultureInfo[]: ~
  -UseDefaultCredentials Switch: ~
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
