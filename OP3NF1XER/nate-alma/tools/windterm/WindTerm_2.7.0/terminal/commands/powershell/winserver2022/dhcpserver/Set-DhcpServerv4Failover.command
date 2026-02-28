description: Modifies the properties of an existing failover relationship
synopses:
- Set-DhcpServerv4Failover [-ComputerName <String>] [-Name] <String> [-AutoStateTransition
  <Boolean>] [-MaxClientLeadTime <TimeSpan>] [-SharedSecret <String>] [-StateSwitchInterval
  <TimeSpan>] [-PartnerDown] [-Force] [-LoadBalancePercent <UInt32>] [-ReservePercent
  <UInt32>] [-PassThru] [-Mode <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutoStateTransition Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -LoadBalancePercent UInt32: ~
  -MaxClientLeadTime TimeSpan: ~
  -Mode String:
    values:
    - LoadBalance
    - HotStandby
  -Name String:
    required: true
  -PartnerDown Switch: ~
  -PassThru Switch: ~
  -ReservePercent UInt32: ~
  -SharedSecret String: ~
  -StateSwitchInterval TimeSpan: ~
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
