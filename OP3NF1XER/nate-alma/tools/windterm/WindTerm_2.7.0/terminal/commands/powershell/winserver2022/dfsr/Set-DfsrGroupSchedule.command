description: Modifies a replication group schedule
synopses:
- Set-DfsrGroupSchedule [-GroupName] <String[]> [[-UseUTC] <Boolean>] [[-ScheduleType]
  <GroupScheduleType>] [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DfsrGroupSchedule [-GroupName] <String[]> [[-UseUTC] <Boolean>] [-Day] <DayOfWeek[]>
  [-BandwidthDetail] <String> [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -DomainName String: ~
  -GroupName,-RG,-RgName String[]:
    required: true
  -ScheduleType GroupScheduleType:
    values:
    - Never
    - Always
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
