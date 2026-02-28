description: Acquires confirmation IDs (CIDs) from the Microsoft licensing servers
  during proxy activation
synopses:
- Get-VamtConfirmationId -FileName <String> [-ProxyUserName <String>] [-ProxyPassword
  <String>] [<CommonParameters>]
- Get-VamtConfirmationId -Products <Product[]> [-ProxyUserName <String>] [-ProxyPassword
  <String>] [<CommonParameters>]
options:
  -FileName String:
    required: true
  -Products Product[]:
    required: true
  -ProxyPassword String: ~
  -ProxyUserName String: ~
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
