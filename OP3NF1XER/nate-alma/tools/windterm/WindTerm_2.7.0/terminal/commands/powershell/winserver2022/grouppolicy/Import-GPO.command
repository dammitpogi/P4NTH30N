description: Imports the Group Policy settings from a backed-up GPO into a specified
  GPO
synopses:
- Import-GPO -BackupId <Guid> -Path <String> [-TargetGuid <Guid>] [-TargetName <String>]
  [-MigrationTable <String>] [-CreateIfNeeded] [-Domain <String>] [-Server <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-GPO -BackupGpoName <String> -Path <String> [-TargetGuid <Guid>] [-TargetName
  <String>] [-MigrationTable <String>] [-CreateIfNeeded] [-Domain <String>] [-Server
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BackupGpoName,-DisplayName String:
    required: true
  -BackupId,-Id Guid:
    required: true
  -Confirm,-cf Switch: ~
  -CreateIfNeeded Switch: ~
  -Domain,-DomainName String: ~
  -MigrationTable String: ~
  -Path,-backupLocation,-BackupDirectory String:
    required: true
  -Server,-DC String: ~
  -TargetGuid Guid: ~
  -TargetName String: ~
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
