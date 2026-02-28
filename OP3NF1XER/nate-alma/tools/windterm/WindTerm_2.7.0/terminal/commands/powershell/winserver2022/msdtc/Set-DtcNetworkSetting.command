description: Modifies DTC network and security configuration for a DTC instance
synopses:
- Set-DtcNetworkSetting [-DtcName <String>] [-InboundTransactionsEnabled <Boolean>]
  [-OutboundTransactionsEnabled <Boolean>] [-RemoteClientAccessEnabled <Boolean>]
  [-RemoteAdministrationAccessEnabled <Boolean>] [-XATransactionsEnabled <Boolean>]
  [-LUTransactionsEnabled <Boolean>] [-AuthenticationLevel <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DtcNetworkSetting [-DtcName <String>] [-DisableNetworkAccess] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthenticationLevel String:
    values:
    - NoAuth
    - Incoming
    - Mutual
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DisableNetworkAccess Switch:
    required: true
  -DtcName String: ~
  -InboundTransactionsEnabled Boolean: ~
  -LUTransactionsEnabled Boolean: ~
  -OutboundTransactionsEnabled Boolean: ~
  -RemoteAdministrationAccessEnabled Boolean: ~
  -RemoteClientAccessEnabled Boolean: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
  -XATransactionsEnabled Boolean: ~
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
