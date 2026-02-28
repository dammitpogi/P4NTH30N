description: Creates a record of all or part of a PowerShell session to a text file
synopses:
- Start-Transcript [[-Path] <String>] [-Append] [-Force] [-NoClobber] [-IncludeInvocationHeader]
  [-UseMinimalHeader] [-WhatIf] [-Confirm]  [<CommonParameters>]
- Start-Transcript [[-LiteralPath] <String>] [-Append] [-Force] [-NoClobber] [-IncludeInvocationHeader]
  [-UseMinimalHeader] [-WhatIf] [-Confirm]  [<CommonParameters>]
- Start-Transcript [[-OutputDirectory] <String>] [-Append] [-Force] [-NoClobber] [-IncludeInvocationHeader]
  [-UseMinimalHeader] [-WhatIf] [-Confirm]  [<CommonParameters>]
options:
  -Append Switch: ~
  -Force Switch: ~
  -IncludeInvocationHeader Switch: ~
  -LiteralPath,-PSPath,-LP System.String: ~
  -NoClobber,-NoOverwrite Switch: ~
  -OutputDirectory System.String: ~
  -Path System.String: ~
  -UseMinimalHeader Switch: ~
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
