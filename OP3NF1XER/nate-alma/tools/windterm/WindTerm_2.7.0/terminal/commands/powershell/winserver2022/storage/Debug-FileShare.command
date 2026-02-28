description: Finds problems with a file share and recommends solutions
synopses:
- Debug-FileShare [-Name] <String[]> [-CimSession <CimSession>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Debug-FileShare -UniqueId <String[]> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Debug-FileShare -InputObject <CimInstance> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -InputObject CimInstance:
    required: true
  -Name String[]:
    required: true
  -ThrottleLimit Int32: ~
  -UniqueId String[]:
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
