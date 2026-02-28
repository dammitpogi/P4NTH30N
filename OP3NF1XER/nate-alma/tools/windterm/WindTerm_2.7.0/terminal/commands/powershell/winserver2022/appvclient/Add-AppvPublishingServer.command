description: Adds a publishing server for the computer that runs the App-V client
synopses:
- Add-AppvPublishingServer [-Name] <String> [-URL] <String> [[-GlobalRefreshEnabled]
  <Boolean>] [[-GlobalRefreshOnLogon] <Boolean>] [[-GlobalRefreshInterval] <UInt32>]
  [[-GlobalRefreshIntervalUnit] <IntervalUnit>] [[-UserRefreshEnabled] <Boolean>]
  [[-UserRefreshOnLogon] <Boolean>] [[-UserRefreshInterval] <UInt32>] [[-UserRefreshIntervalUnit]
  <IntervalUnit>] [<CommonParameters>]
options:
  -GlobalRefreshEnabled Boolean: ~
  -GlobalRefreshInterval UInt32: ~
  -GlobalRefreshIntervalUnit IntervalUnit:
    values:
    - Hour
    - Day
  -GlobalRefreshOnLogon Boolean: ~
  -Name String:
    required: true
  -URL String:
    required: true
  -UserRefreshEnabled Boolean: ~
  -UserRefreshInterval UInt32: ~
  -UserRefreshIntervalUnit IntervalUnit:
    values:
    - Hour
    - Day
  -UserRefreshOnLogon Boolean: ~
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
