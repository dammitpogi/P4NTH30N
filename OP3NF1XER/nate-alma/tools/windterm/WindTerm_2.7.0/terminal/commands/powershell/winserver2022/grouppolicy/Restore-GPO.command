description: Restores one GPO or all GPOs in a domain from one or more GPO backup
  files
synopses:
- Restore-GPO -BackupId <Guid> -Path <String> [-Domain <String>] [-Server <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Restore-GPO -Guid <Guid> -Path <String> [-Domain <String>] [-Server <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Restore-GPO [-Name] <String> -Path <String> [-Domain <String>] [-Server <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Restore-GPO -Path <String> [-Domain <String>] [-Server <String>] [-All] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -BackupId,-Id Guid:
    required: true
  -Confirm,-cf Switch: ~
  -Domain,-DomainName String: ~
  -Guid Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -Path,-backupLocation,-BackupDirectory String:
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
