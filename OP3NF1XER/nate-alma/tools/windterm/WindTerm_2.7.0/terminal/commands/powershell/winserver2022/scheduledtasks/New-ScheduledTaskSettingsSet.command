description: Creates a new scheduled task settings object
synopses:
- New-ScheduledTaskSettingsSet [-DisallowDemandStart] [-DisallowHardTerminate] [-Compatibility
  <CompatibilityEnum>] [-DeleteExpiredTaskAfter <TimeSpan>] [-AllowStartIfOnBatteries]
  [-Disable] [-MaintenanceExclusive] [-Hidden] [-RunOnlyIfIdle] [-IdleWaitTimeout
  <TimeSpan>] [-NetworkId <String>] [-NetworkName <String>] [-DisallowStartOnRemoteAppSession]
  [-MaintenancePeriod <TimeSpan>] [-MaintenanceDeadline <TimeSpan>] [-StartWhenAvailable]
  [-DontStopIfGoingOnBatteries] [-WakeToRun] [-IdleDuration <TimeSpan>] [-RestartOnIdle]
  [-DontStopOnIdleEnd] [-ExecutionTimeLimit <TimeSpan>] [-MultipleInstances <MultipleInstancesEnum>]
  [-Priority <Int32>] [-RestartCount <Int32>] [-RestartInterval <TimeSpan>] [-RunOnlyIfNetworkAvailable]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AllowStartIfOnBatteries Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Compatibility CompatibilityEnum:
    values:
    - At
    - V1
    - Vista
    - Win7
    - Win8
  -DeleteExpiredTaskAfter TimeSpan: ~
  -Disable Switch: ~
  -DisallowDemandStart Switch: ~
  -DisallowHardTerminate Switch: ~
  -DisallowStartOnRemoteAppSession Switch: ~
  -DontStopIfGoingOnBatteries Switch: ~
  -DontStopOnIdleEnd Switch: ~
  -ExecutionTimeLimit TimeSpan: ~
  -Hidden Switch: ~
  -IdleDuration TimeSpan: ~
  -IdleWaitTimeout TimeSpan: ~
  -MaintenanceDeadline TimeSpan: ~
  -MaintenanceExclusive Switch: ~
  -MaintenancePeriod TimeSpan: ~
  -MultipleInstances MultipleInstancesEnum:
    values:
    - Parallel
    - Queue
    - IgnoreNew
  -NetworkId String: ~
  -NetworkName String: ~
  -Priority Int32: ~
  -RestartCount Int32: ~
  -RestartInterval TimeSpan: ~
  -RestartOnIdle Switch: ~
  -RunOnlyIfIdle Switch: ~
  -RunOnlyIfNetworkAvailable Switch: ~
  -StartWhenAvailable Switch: ~
  -ThrottleLimit Int32: ~
  -WakeToRun Switch: ~
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
