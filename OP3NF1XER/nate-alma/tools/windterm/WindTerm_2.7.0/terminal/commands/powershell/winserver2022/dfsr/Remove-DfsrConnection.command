description: Removes a connection between members of a replication group
synopses:
- Remove-DfsrConnection [-GroupName] <String[]> [-SourceComputerName] <String> [-DestinationComputerName]
  <String> [-Force] [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DestinationComputerName,-ReceivingMember,-RMem String:
    required: true
  -DomainName String: ~
  -Force Switch: ~
  -GroupName,-RG,-RgName String[]:
    required: true
  -SourceComputerName,-SendingMember,-SMem String:
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
