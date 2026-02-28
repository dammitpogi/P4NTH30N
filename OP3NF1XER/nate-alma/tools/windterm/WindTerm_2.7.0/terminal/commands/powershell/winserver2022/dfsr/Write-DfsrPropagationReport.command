description: Generates reports for propagation test files in a replication group
synopses:
- Write-DfsrPropagationReport [-GroupName] <String[]> [-FolderName] <String[]> [-ReferenceComputerName]
  <String> [[-Path] <String>] [[-FileCount] <Int32>] [[-DomainName] <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DomainName String: ~
  -FileCount Int32: ~
  -FolderName,-RF,-RfName String[]:
    required: true
  -GroupName,-RG,-RgName String[]:
    required: true
  -Path,-FilePath String: ~
  -ReferenceComputerName,-ReferenceMember,-RefMem String:
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
