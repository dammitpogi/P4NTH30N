description: Backs up one GPO or all the GPOs in a domain
synopses:
- Backup-GPO -Guid <Guid> -Path <String> [-Comment <String>] [-Domain <String>] [-Server
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Backup-GPO [-Name] <String> -Path <String> [-Comment <String>] [-Domain <String>]
  [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Backup-GPO -Path <String> [-Comment <String>] [-Domain <String>] [-Server <String>]
  [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -Comment String: ~
  -Confirm,-cf Switch: ~
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -Path,-backupLocation String:
    required: true
  -Server,-DC String: ~
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
