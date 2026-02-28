description: Registers a scheduled task definition on a local computer
synopses:
- Register-ScheduledTask [-Force] [[-Password] <String>] [[-User] <String>] [-TaskName]
  <String> [[-TaskPath] <String>] [-Action] <CimInstance[]> [[-Description] <String>]
  [[-Settings] <CimInstance>] [[-Trigger] <CimInstance[]>] [[-RunLevel] <RunLevelEnum>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Register-ScheduledTask [-Force] [[-Password] <String>] [[-User] <String>] [-TaskName]
  <String> [[-TaskPath] <String>] [-Xml] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Register-ScheduledTask [-Force] [-TaskName] <String> [[-TaskPath] <String>] [[-Principal]
  <CimInstance>] [-Action] <CimInstance[]> [[-Description] <String>] [[-Settings]
  <CimInstance>] [[-Trigger] <CimInstance[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Register-ScheduledTask [-Force] [-InputObject] <CimInstance> [[-Password] <String>]
  [[-User] <String>] [[-TaskName] <String>] [[-TaskPath] <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Action CimInstance[]:
    required: true
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Description String: ~
  -Force Switch: ~
  -InputObject CimInstance:
    required: true
  -Password String: ~
  -Principal CimInstance: ~
  -RunLevel RunLevelEnum:
    values:
    - Limited
    - Highest
  -Settings CimInstance: ~
  -TaskName String:
    required: true
  -TaskPath String: ~
  -ThrottleLimit Int32: ~
  -Trigger CimInstance[]: ~
  -User String: ~
  -Xml String:
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
