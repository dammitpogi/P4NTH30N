description: Sets a prediction schedule for the specified capabilities
synopses:
- Set-InsightsCapabilitySchedule [-Name] <String> [-Daily] [[-DaysInterval] <UInt16>]
  [[-At] <DateTime>] [[-ComputerName] <String>] [-Credential <PSCredential>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-InsightsCapabilitySchedule [-Name] <String> [-Daily] [[-DaysOfWeek] <DayOfWeek[]>]
  [[-At] <DateTime>] [[-ComputerName] <String>] [-Credential <PSCredential>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-InsightsCapabilitySchedule [-Name] <String> [[-DaysOfWeek] <DayOfWeek[]>] [-Minute]
  [[-MinutesInterval] <UInt16>] [[-ComputerName] <String>] [-Credential <PSCredential>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-InsightsCapabilitySchedule [-Name] <String> [[-DaysOfWeek] <DayOfWeek[]>] [-Hourly]
  [[-HoursInterval] <UInt16>] [[-ComputerName] <String>] [-Credential <PSCredential>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-InsightsCapabilitySchedule [-Name] <String> [-DefaultSchedule] [[-ComputerName]
  <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -At,-A DateTime: ~
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Daily,-D Switch:
    required: true
  -DaysInterval,-DI UInt16: ~
  -DaysOfWeek,-DOW DayOfWeek[]:
    values:
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
  -DefaultSchedule,-DS Switch:
    required: true
  -Hourly,-H Switch:
    required: true
  -HoursInterval,-HI UInt16: ~
  -Minute,-M Switch:
    required: true
  -MinutesInterval,-MI UInt16: ~
  -Name,-N String:
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
