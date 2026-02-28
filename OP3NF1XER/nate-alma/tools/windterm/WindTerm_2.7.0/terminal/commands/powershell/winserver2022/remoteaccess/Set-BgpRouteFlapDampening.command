description: Configures the BGP route dampening engine
synopses:
- Set-BgpRouteFlapDampening [-RoutingDomain <String>] [-ReuseThreshold <UInt32>] [-SuppressThreshold
  <UInt32>] [-HalfLife <UInt32>] [-HalfLifeUnreachable <UInt32>] [-MaxSuppressTime
  <UInt32>] [-Force] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -HalfLife UInt32: ~
  -HalfLifeUnreachable UInt32: ~
  -MaxSuppressTime UInt32: ~
  -PassThru Switch: ~
  -ReuseThreshold UInt32: ~
  -RoutingDomain,-RoutingDomainName String: ~
  -SuppressThreshold UInt32: ~
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
