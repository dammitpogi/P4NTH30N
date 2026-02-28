description: Creates a replicated folder in a replication group
synopses:
- New-DfsReplicatedFolder [-GroupName] <String[]> [-FolderName] <String[]> [[-Description]
  <String>] [[-FileNameToExclude] <String[]>] [[-DirectoryNameToExclude] <String[]>]
  [[-DfsnPath] <String>] [-CreateDisabledMemberships] [[-DomainName] <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -CreateDisabledMemberships Switch: ~
  -Description String: ~
  -DfsnPath String: ~
  -DirectoryNameToExclude,-DirectoryFilter String[]: ~
  -DomainName String: ~
  -FileNameToExclude,-FileFilter String[]: ~
  -FolderName,-RF,-RfName String[]:
    required: true
  -GroupName,-RG,-RgName String[]:
    required: true
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
