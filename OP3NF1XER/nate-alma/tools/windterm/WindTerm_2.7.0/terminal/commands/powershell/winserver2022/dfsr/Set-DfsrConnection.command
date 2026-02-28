description: Changes the settings of a connection between members of a replication
  group
synopses:
- Set-DfsrConnection [[-GroupName] <String[]>] [-SourceComputerName] <String> [-DestinationComputerName]
  <String> [[-DisableConnection] <Boolean>] [[-DisableRDC] <Boolean>] [[-DisableCrossFileRDC]
  <Boolean>] [[-Description] <String>] [[-MinimumRDCFileSizeInKB] <Int64>] [[-DomainName]
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DestinationComputerName,-ReceivingMember,-RMem String:
    required: true
  -DisableConnection Boolean: ~
  -DisableCrossFileRDC Boolean: ~
  -DisableRDC Boolean: ~
  -DomainName String: ~
  -GroupName,-RG,-RgName String[]: ~
  -MinimumRDCFileSizeInKB Int64: ~
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
