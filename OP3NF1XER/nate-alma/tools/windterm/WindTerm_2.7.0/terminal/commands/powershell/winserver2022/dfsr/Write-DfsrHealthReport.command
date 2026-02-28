description: Generates a DFS Replication health report
synopses:
- Write-DfsrHealthReport [-GroupName] <String[]> [[-ReferenceComputerName] <String>]
  [[-MemberComputerName] <String[]>] [[-Path] <String>] [-CountFiles] [[-DomainName]
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -CountFiles Switch: ~
  -DomainName String: ~
  -GroupName,-RG,-RgName String[]:
    required: true
  -MemberComputerName,-MemberList,-MemList String[]: ~
  -Path,-FilePath String: ~
  -ReferenceComputerName,-ReferenceMember,-RefMem String: ~
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
