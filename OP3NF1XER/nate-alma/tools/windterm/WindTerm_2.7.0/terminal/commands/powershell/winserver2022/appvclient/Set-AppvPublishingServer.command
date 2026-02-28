description: Modifies properties of an App-V Publishing Server
synopses:
- Set-AppvPublishingServer [-ServerId] <UInt32> [[-GlobalRefreshEnabled] <Boolean>]
  [[-GlobalRefreshOnLogon] <Boolean>] [[-GlobalRefreshInterval] <UInt32>] [[-GlobalRefreshIntervalUnit]
  <IntervalUnit>] [[-UserRefreshEnabled] <Boolean>] [[-UserRefreshOnLogon] <Boolean>]
  [[-UserRefreshInterval] <UInt32>] [[-UserRefreshIntervalUnit] <IntervalUnit>] [<CommonParameters>]
- Set-AppvPublishingServer [-Server] <AppvPublishingServer> [[-GlobalRefreshEnabled]
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
  -Server AppvPublishingServer:
    required: true
  -ServerId UInt32:
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
