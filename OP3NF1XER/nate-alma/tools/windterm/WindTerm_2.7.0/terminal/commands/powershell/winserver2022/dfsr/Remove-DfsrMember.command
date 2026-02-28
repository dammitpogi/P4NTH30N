description: Removes computers from a replication group
synopses:
- Remove-DfsrMember [-GroupName] <String[]> [-ComputerName] <String[]> [-Force] [[-DomainName]
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-MemberList,-MemList String[]:
    required: true
  -Confirm,-cf Switch: ~
  -DomainName String: ~
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
