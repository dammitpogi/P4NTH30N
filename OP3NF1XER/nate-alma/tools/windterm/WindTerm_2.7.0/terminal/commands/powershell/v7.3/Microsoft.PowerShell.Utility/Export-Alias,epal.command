description: Exports information about currently defined aliases to a file
synopses:
- Export-Alias [-Path] <String> [[-Name] <String[]>] [-PassThru] [-As <ExportAliasFormat>]
  [-Append] [-Force] [-NoClobber] [-Description <String>] [-Scope <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Export-Alias -LiteralPath <String> [[-Name] <String[]>] [-PassThru] [-As <ExportAliasFormat>]
  [-Append] [-Force] [-NoClobber] [-Description <String>] [-Scope <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Append Switch: ~
  -As Microsoft.PowerShell.Commands.ExportAliasFormat:
    values:
    - Csv
    - Script
  -Description System.String: ~
  -Force Switch: ~
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -Name System.String[]: ~
  -NoClobber,-NoOverwrite Switch: ~
  -PassThru Switch: ~
  -Path System.String:
    required: true
  -Scope System.String: ~
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
