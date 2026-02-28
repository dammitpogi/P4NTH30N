description: Modifies a scheduled task
synopses:
- Set-ScheduledTask [[-Password] <String>] [[-User] <String>] [[-Action] <CimInstance[]>]
  [[-TaskPath] <String>] [[-Settings] <CimInstance>] [[-Trigger] <CimInstance[]>]
  [-TaskName] <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-ScheduledTask [-InputObject] <CimInstance> [[-Password] <String>] [[-User] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-ScheduledTask [[-Principal] <CimInstance>] [[-Action] <CimInstance[]>] [[-TaskPath]
  <String>] [[-Settings] <CimInstance>] [[-Trigger] <CimInstance[]>] [-TaskName] <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Action CimInstance[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance:
    required: true
  -Password String: ~
  -Principal CimInstance: ~
  -Settings CimInstance: ~
  -TaskName String:
    required: true
  -TaskPath String: ~
  -ThrottleLimit Int32: ~
  -Trigger CimInstance[]: ~
  -User String: ~
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
