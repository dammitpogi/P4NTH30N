description: Gets dynamic keyword addresses
synopses:
- Get-NetFirewallDynamicKeywordAddress [-All] [-PolicyStore <String>] [-AllAutoResolve]
  [-AllNonAutoResolve] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetFirewallDynamicKeywordAddress [-Id] <String[]> [-PolicyStore <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AllAutoResolve Switch: ~
  -AllNonAutoResolve Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Id String[]:
    required: true
  -PolicyStore String: ~
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
