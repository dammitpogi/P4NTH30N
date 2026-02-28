description: Adds an IPv4 failover relationship on the DHCP server service
synopses:
- Add-DhcpServerv4Failover [-ComputerName <String>] [-Name] <String> [-PartnerServer]
  <String> [-ScopeId] <IPAddress[]> [-MaxClientLeadTime <TimeSpan>] [-AutoStateTransition
  <Boolean>] [-StateSwitchInterval <TimeSpan>] [-Force] [-SharedSecret <String>] [-PassThru]
  [-LoadBalancePercent <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DhcpServerv4Failover [-ComputerName <String>] [-Name] <String> [-PartnerServer]
  <String> [-ScopeId] <IPAddress[]> [-MaxClientLeadTime <TimeSpan>] [-AutoStateTransition
  <Boolean>] [-StateSwitchInterval <TimeSpan>] [-Force] [-SharedSecret <String>] [-PassThru]
  [-ReservePercent <UInt32>] [-ServerRole <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
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
  -Name String:
    required: true
  -PartnerServer String:
    required: true
  -PassThru Switch: ~
  -ReservePercent UInt32: ~
  -ScopeId IPAddress[]:
    required: true
  -ServerRole String:
    values:
    - Active
    - Standby
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
