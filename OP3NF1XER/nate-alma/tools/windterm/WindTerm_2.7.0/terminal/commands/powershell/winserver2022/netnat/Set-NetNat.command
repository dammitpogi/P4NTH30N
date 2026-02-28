description: Modifies settings for NAT objects
synopses:
- Set-NetNat [-Name] <String[]> [-IcmpQueryTimeout <UInt32>] [-TcpEstablishedConnectionTimeout
  <UInt32>] [-TcpTransientConnectionTimeout <UInt32>] [-TcpFilteringBehavior <FilteringBehaviorType>]
  [-UdpFilteringBehavior <FilteringBehaviorType>] [-UdpIdleSessionTimeout <UInt32>]
  [-UdpInboundRefresh <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetNat -InputObject <CimInstance[]> [-IcmpQueryTimeout <UInt32>] [-TcpEstablishedConnectionTimeout
  <UInt32>] [-TcpTransientConnectionTimeout <UInt32>] [-TcpFilteringBehavior <FilteringBehaviorType>]
  [-UdpFilteringBehavior <FilteringBehaviorType>] [-UdpIdleSessionTimeout <UInt32>]
  [-UdpInboundRefresh <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IcmpQueryTimeout UInt32: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -TcpEstablishedConnectionTimeout UInt32: ~
  -TcpFilteringBehavior FilteringBehaviorType:
    values:
    - EndpointIndependentFiltering
    - AddressDependentFiltering
  -TcpTransientConnectionTimeout UInt32: ~
  -ThrottleLimit Int32: ~
  -UdpFilteringBehavior FilteringBehaviorType:
    values:
    - EndpointIndependentFiltering
    - AddressDependentFiltering
  -UdpIdleSessionTimeout UInt32: ~
  -UdpInboundRefresh Boolean:
    values:
    - 'False'
    - 'True'
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
