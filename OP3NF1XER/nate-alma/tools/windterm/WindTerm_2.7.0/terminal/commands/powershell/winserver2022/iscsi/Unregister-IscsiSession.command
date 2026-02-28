description: Removes an active iSCSI session from being persistent using the session
  identifier as input
synopses:
- Unregister-IscsiSession -SessionIdentifier <String[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Unregister-IscsiSession -InputObject <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -SessionIdentifier String[]:
    required: true
  -ThrottleLimit Int32: ~
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
