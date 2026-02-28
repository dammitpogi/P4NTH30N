description: Removes virtual network routes
synopses:
- Remove-NetVirtualizationCustomerRoute [-RoutingDomainID <String[]>] [-VirtualSubnetID
  <UInt32[]>] [-DestinationPrefix <String[]>] [-NextHop <String[]>] [-Metric <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Remove-NetVirtualizationCustomerRoute -InputObject <CimInstance[]> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DestinationPrefix String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Metric UInt32[]: ~
  -NextHop String[]: ~
  -PassThru Switch: ~
  -RoutingDomainID String[]: ~
  -ThrottleLimit Int32: ~
  -VirtualSubnetID UInt32[]: ~
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
