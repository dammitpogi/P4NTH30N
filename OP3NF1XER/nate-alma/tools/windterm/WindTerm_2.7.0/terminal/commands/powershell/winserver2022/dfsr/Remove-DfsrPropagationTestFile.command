description: Removes DFS Replication propagation test files
synopses:
- Remove-DfsrPropagationTestFile [-GroupName] <String[]> [-FolderName] <String[]>
  [[-ComputerName] <String>] [-AgeInDays] <UInt32> [-Force] [[-DomainName] <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AgeInDays UInt32:
    required: true
  -ComputerName,-Member,-Mem String: ~
  -Confirm,-cf Switch: ~
  -DomainName String: ~
  -FolderName,-RF,-RfName String[]:
    required: true
  -Force Switch: ~
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
