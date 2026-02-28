description: Gets transport filters
synopses:
- Get-NetTransportFilter [-SettingName <String[]>] [-Protocol <Protocol[]>] [-LocalPortStart
  <UInt16[]>] [-LocalPortEnd <UInt16[]>] [-RemotePortStart <UInt16[]>] [-RemotePortEnd
  <UInt16[]>] [-DestinationPrefix <String[]>] [-AssociatedTCPSetting <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedTCPSetting CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -DestinationPrefix String[]: ~
  -LocalPortEnd UInt16[]: ~
  -LocalPortStart UInt16[]: ~
  -Protocol Protocol[]:
    values:
    - TCP
    - UDP
  -RemotePortEnd UInt16[]: ~
  -RemotePortStart UInt16[]: ~
  -SettingName String[]: ~
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
