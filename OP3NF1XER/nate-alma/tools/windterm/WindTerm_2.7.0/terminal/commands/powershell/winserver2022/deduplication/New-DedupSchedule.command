description: Creates a data deduplication schedule
synopses:
- New-DedupSchedule [-Name] <String> [-Type] <Type> [-DurationHours <UInt32>] [-Disable]
  [-StopWhenSystemBusy] [-Memory <UInt32>] [-Cores <UInt32>] [-Priority <Priority>]
  [-InputOutputThrottle <UInt32>] [-InputOutputThrottleLevel <InputOutputThrottleLevel>]
  [-Start <DateTime>] [-Days <DayOfWeek[]>] [-Full] [-ReadOnly] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Cores,-MaximumCoresPercentage UInt32: ~
  -Days DayOfWeek[]:
    values:
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
  -Disable Switch: ~
  -DurationHours UInt32: ~
  -Full Switch: ~
  -InputOutputThrottle UInt32: ~
  -InputOutputThrottleLevel InputOutputThrottleLevel:
    values:
    - None
    - Low
    - Medium
    - High
    - Maximum
  -Memory,-MaximumMemoryPercentage UInt32: ~
  -Name String:
    required: true
  -Priority Priority:
    values:
    - Low
    - Normal
    - High
  -ReadOnly Switch: ~
  -Start DateTime: ~
  -StopWhenSystemBusy Switch: ~
  -ThrottleLimit Int32: ~
  -Type Type:
    required: true
    values:
    - Optimization
    - GarbageCollection
    - Scrubbing
    - Unoptimization
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
