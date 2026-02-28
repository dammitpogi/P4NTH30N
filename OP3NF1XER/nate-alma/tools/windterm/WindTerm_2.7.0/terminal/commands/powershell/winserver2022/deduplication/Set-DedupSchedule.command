description: Changes configuration settings for data deduplication schedules
synopses:
- Set-DedupSchedule [-Name] <String[]> [-Type <Type[]>] [-DurationHours <UInt32>]
  [-Enabled <Boolean>] [-StopWhenSystemBusy <Boolean>] [-Memory <UInt32>] [-Cores
  <UInt32>] [-Priority <Priority>] [-InputOutputThrottle <UInt32>] [-InputOutputThrottleLevel
  <InputOutputThrottleLevel>] [-Start <DateTime>] [-Days <DayOfWeek[]>] [-Full <Boolean>]
  [-ReadOnly <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
- Set-DedupSchedule -InputObject <CimInstance[]> [-DurationHours <UInt32>] [-Enabled
  <Boolean>] [-StopWhenSystemBusy <Boolean>] [-Memory <UInt32>] [-Cores <UInt32>]
  [-Priority <Priority>] [-InputOutputThrottle <UInt32>] [-InputOutputThrottleLevel
  <InputOutputThrottleLevel>] [-Start <DateTime>] [-Days <DayOfWeek[]>] [-Full <Boolean>]
  [-ReadOnly <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
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
  -DurationHours UInt32: ~
  -Enabled Boolean: ~
  -Full Boolean: ~
  -InputObject CimInstance[]:
    required: true
  -InputOutputThrottle UInt32: ~
  -InputOutputThrottleLevel InputOutputThrottleLevel:
    values:
    - None
    - Low
    - Medium
    - High
    - Maximum
  -Memory,-MaximumMemoryPercentage UInt32: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -Priority Priority:
    values:
    - Low
    - Normal
    - High
  -ReadOnly Boolean: ~
  -Start DateTime: ~
  -StopWhenSystemBusy Boolean: ~
  -ThrottleLimit Int32: ~
  -Type Type[]:
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
