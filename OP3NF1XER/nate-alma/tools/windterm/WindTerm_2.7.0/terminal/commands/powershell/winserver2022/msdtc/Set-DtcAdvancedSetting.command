description: Sets DTC instance specific properties in the registry
synopses:
- Set-DtcAdvancedSetting [-DtcName <String>] [-Subkey <String>] -Name <String> -Value
  <String> -Type <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DtcName String: ~
  -Name String:
    required: true
  -Subkey String: ~
  -ThrottleLimit Int32: ~
  -Type String:
    required: true
    values:
    - String
    - DWORD
  -Value String:
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
