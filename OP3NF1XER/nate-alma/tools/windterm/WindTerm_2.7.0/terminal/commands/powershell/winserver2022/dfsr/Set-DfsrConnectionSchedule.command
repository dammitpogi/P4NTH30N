description: Changes the settings of a connection schedule between members of a replication
  group
synopses:
- Set-DfsrConnectionSchedule [[-GroupName] <String[]>] [-SourceComputerName] <String>
  [-DestinationComputerName] <String> [[-UseUTC] <Boolean>] [[-ScheduleType] <ConnectionScheduleType>]
  [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DfsrConnectionSchedule [[-GroupName] <String[]>] [-SourceComputerName] <String>
  [-DestinationComputerName] <String> [[-UseUTC] <Boolean>] [-Day] <DayOfWeek[]> [-BandwidthDetail]
  <String> [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BandwidthDetail String:
    required: true
  -Confirm,-cf Switch: ~
  -Day DayOfWeek[]:
    required: true
    values:
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
  -DestinationComputerName,-ReceivingMember,-RMem String:
    required: true
  -DomainName String: ~
  -GroupName,-RG,-RgName String[]: ~
  -ScheduleType ConnectionScheduleType:
    values:
    - UseGroupSchedule
    - Never
    - Always
  -SourceComputerName,-SendingMember,-SMem String:
    required: true
  -UseUTC Boolean: ~
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
