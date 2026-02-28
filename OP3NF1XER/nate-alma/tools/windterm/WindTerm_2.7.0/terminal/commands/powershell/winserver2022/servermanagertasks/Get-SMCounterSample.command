description: Gets performance counter samples for a particular time or period of time
synopses:
- Get-SMCounterSample -CollectorName <String> -CounterPath <String[]> [-BatchSize
  <UInt32>] [-StartTime <DateTime>] [-EndTime <DateTime>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-SMCounterSample -CollectorName <String> -CounterPath <String[]> -Timestamp <DateTime[]>
  [-BatchSize <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BatchSize UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -CollectorName String:
    required: true
  -CounterPath String[]:
    required: true
  -EndTime DateTime: ~
  -StartTime DateTime: ~
  -ThrottleLimit Int32: ~
  -Timestamp DateTime[]:
    required: true
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
