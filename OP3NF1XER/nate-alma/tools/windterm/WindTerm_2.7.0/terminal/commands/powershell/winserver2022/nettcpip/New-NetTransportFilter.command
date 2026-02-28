description: Creates a transport filter
synopses:
- New-NetTransportFilter -SettingName <String> [-Protocol <Protocol>] [-LocalPortStart
  <UInt16>] [-LocalPortEnd <UInt16>] [-RemotePortStart <UInt16>] [-RemotePortEnd <UInt16>]
  [-DestinationPrefix <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DestinationPrefix String: ~
  -LocalPortEnd UInt16: ~
  -LocalPortStart UInt16: ~
  -Protocol Protocol:
    values:
    - TCP
    - UDP
  -RemotePortEnd UInt16: ~
  -RemotePortStart UInt16: ~
  -SettingName String:
    required: true
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
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
