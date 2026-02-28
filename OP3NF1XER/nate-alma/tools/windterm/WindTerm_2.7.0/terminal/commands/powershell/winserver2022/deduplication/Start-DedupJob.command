description: Starts a data deduplication job
synopses:
- Start-DedupJob [-Type] <Type> [[-Volume] <String[]>] [-StopWhenSystemBusy] [-Memory
  <UInt32>] [-Cores <UInt32>] [-Priority <Priority>] [-InputOutputThrottle <UInt32>]
  [-InputOutputThrottleLevel <InputOutputThrottleLevel>] [-Preempt] [-Wait] [-Full]
  [-ReadOnly] [-Timestamp <DateTime>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Cores,-MaximumCoresPercentage UInt32: ~
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
  -Preempt Switch: ~
  -Priority Priority:
    values:
    - Low
    - Normal
    - High
  -ReadOnly Switch: ~
  -StopWhenSystemBusy Switch: ~
  -ThrottleLimit Int32: ~
  -Timestamp DateTime: ~
  -Type Type:
    required: true
    values:
    - Optimization
    - GarbageCollection
    - Scrubbing
    - Unoptimization
  -Volume,-Path,-Name,-DeviceId String[]: ~
  -Wait Switch: ~
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
