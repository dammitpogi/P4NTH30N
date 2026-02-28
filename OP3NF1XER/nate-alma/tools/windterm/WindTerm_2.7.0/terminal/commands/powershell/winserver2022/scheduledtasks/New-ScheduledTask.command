description: Creates a scheduled task instance
synopses:
- New-ScheduledTask [[-Action] <CimInstance[]>] [[-Description] <String>] [[-Principal]
  <CimInstance>] [[-Settings] <CimInstance>] [[-Trigger] <CimInstance[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Action CimInstance[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Description String: ~
  -Principal CimInstance: ~
  -Settings CimInstance: ~
  -ThrottleLimit Int32: ~
  -Trigger CimInstance[]: ~
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
