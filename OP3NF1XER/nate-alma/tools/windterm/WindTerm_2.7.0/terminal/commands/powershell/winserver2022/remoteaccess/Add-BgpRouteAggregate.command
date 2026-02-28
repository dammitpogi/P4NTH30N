description: Adds a new aggregate route for specific BGP routes
synopses:
- Add-BgpRouteAggregate [-RoutingDomain <String>] -Prefix <String> [-SummaryOnly <SummaryOnly>]
  [-AttributePolicy <String[]>] [-PreserveASPath <PreserveASPath>] [-PassThru] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AttributePolicy String[]: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -PassThru Switch: ~
  -Prefix,-AggregatePrefix String:
    required: true
  -PreserveASPath PreserveASPath:
    values:
    - Disabled
    - Enabled
  -RoutingDomain,-RoutingDomainName String: ~
  -SummaryOnly SummaryOnly:
    values:
    - Disabled
    - Enabled
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
