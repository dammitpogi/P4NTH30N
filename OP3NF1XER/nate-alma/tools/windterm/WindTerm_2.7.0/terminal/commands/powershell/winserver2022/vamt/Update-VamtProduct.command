description: Updates the VAMT database by querying the computers for their current
  status
synopses:
- Update-VamtProduct -Products <Product[]> [-DbConnectionString <String>] [-Username
  <String>] [-Password <String>] [-DbCommandTimeout <Int32>] [<CommonParameters>]
options:
  -DbCommandTimeout Int32: ~
  -DbConnectionString String: ~
  -Password String: ~
  -Products Product[]:
    required: true
  -Username String: ~
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
