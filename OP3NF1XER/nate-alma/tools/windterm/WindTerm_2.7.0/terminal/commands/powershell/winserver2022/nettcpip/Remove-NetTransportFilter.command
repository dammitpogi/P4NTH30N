description: Removes transport filters
synopses:
- Remove-NetTransportFilter [-SettingName <String[]>] [-Protocol <Protocol[]>] [-LocalPortStart
  <UInt16[]>] [-LocalPortEnd <UInt16[]>] [-RemotePortStart <UInt16[]>] [-RemotePortEnd
  <UInt16[]>] [-DestinationPrefix <String[]>] [-AssociatedTCPSetting <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-NetTransportFilter -InputObject <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedTCPSetting CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DestinationPrefix String[]: ~
  -InputObject CimInstance[]:
    required: true
  -LocalPortEnd UInt16[]: ~
  -LocalPortStart UInt16[]: ~
  -PassThru Switch: ~
  -Protocol Protocol[]:
    values:
    - TCP
    - UDP
  -RemotePortEnd UInt16[]: ~
  -RemotePortStart UInt16[]: ~
  -SettingName String[]: ~
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
