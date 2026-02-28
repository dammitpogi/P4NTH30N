description: Creates a scheduled task trigger object
synopses:
- New-ScheduledTaskTrigger [-RandomDelay <TimeSpan>] -At <DateTime> [-Once] [-RepetitionDuration
  <TimeSpan>] [-RepetitionInterval <TimeSpan>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- New-ScheduledTaskTrigger [-Daily] [-DaysInterval <UInt32>] [-RandomDelay <TimeSpan>]
  -At <DateTime> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-ScheduledTaskTrigger [-RandomDelay <TimeSpan>] -At <DateTime> [-DaysOfWeek <DayOfWeek[]>]
  [-Weekly] [-WeeksInterval <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- New-ScheduledTaskTrigger [-RandomDelay <TimeSpan>] [-AtStartup] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-ScheduledTaskTrigger [-RandomDelay <TimeSpan>] [-AtLogOn] [-User <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -At DateTime:
    required: true
  -AtLogOn Switch:
    required: true
  -AtStartup Switch:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Daily Switch:
    required: true
  -DaysInterval UInt32: ~
  -DaysOfWeek DayOfWeek[]:
    values:
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
  -Once Switch:
    required: true
  -RandomDelay TimeSpan: ~
  -RepetitionDuration TimeSpan: ~
  -RepetitionInterval TimeSpan: ~
  -ThrottleLimit Int32: ~
  -User String: ~
  -Weekly Switch:
    required: true
  -WeeksInterval UInt32: ~
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
