description: Updates an IPsec rule by adding or removing a set of IP addresses
synopses:
- Update-NetIPsecRule -IPsecRuleName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] -Action <ChangeAction> [-IPv6Addresses <String[]>] [-IPv4Addresses <String[]>]
  -EndpointType <EndpointType> [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-NetIPsecRule -InputObject <CimInstance[]> -Action <ChangeAction> [-IPv6Addresses
  <String[]>] [-IPv4Addresses <String[]>] -EndpointType <EndpointType> [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Action ChangeAction:
    required: true
    values:
    - Add
    - Delete
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EndpointType EndpointType:
    required: true
    values:
    - Endpoint1
    - Endpoint2
  -GPOSession String: ~
  -IPsecRuleName,-ID,-Name String[]:
    required: true
  -IPv4Addresses String[]: ~
  -IPv6Addresses String[]: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
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
