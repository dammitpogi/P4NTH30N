description: Changes settings for a clustered scheduled task
synopses:
- Set-ClusteredScheduledTask [-TaskName] <String> [[-Cluster] <String>] [-Xml] <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-ClusteredScheduledTask [-TaskName] <String> [[-Cluster] <String>] [[-Action]
  <CimInstance[]>] [[-Settings] <CimInstance>] [[-Trigger] <CimInstance[]>] [[-Description]
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-ClusteredScheduledTask [-TaskName] <String> [[-Cluster] <String>] [-InputObject]
  <CimInstance> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Action CimInstance[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Cluster String: ~
  -Description String: ~
  -InputObject CimInstance:
    required: true
  -Settings CimInstance: ~
  -TaskName String:
    required: true
  -ThrottleLimit Int32: ~
  -Trigger CimInstance[]: ~
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
