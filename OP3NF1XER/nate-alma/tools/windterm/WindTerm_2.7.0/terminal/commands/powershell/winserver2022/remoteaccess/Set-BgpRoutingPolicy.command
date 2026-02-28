description: Modifies a routing policy configuration
synopses:
- Set-BgpRoutingPolicy [-Name] <String> [-PassThru] [-PolicyType <PolicyType>] [-RoutingDomain
  <String>] [-Force] [-AddCommunity <String[]>] [-RemoveCommunity <String[]>] [-RemovePolicyClause
  <String[]>] [-MatchASNRange <UInt32[]>] [-IgnorePrefix <String[]>] [-MatchCommunity
  <String[]>] [-MatchPrefix <String[]>] [-MatchNextHop <IPAddress[]>] [-NewLocalPref
  <UInt32>] [-NewMED <UInt32>] [-NewNextHop <IPAddress>] [-ClearMED] [-RemoveAllCommunities]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AddCommunity String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClearMED Switch: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -IgnorePrefix String[]: ~
  -MatchASNRange UInt32[]: ~
  -MatchCommunity String[]: ~
  -MatchNextHop IPAddress[]: ~
  -MatchPrefix String[]: ~
  -Name,-PolicyId,-PolicyName String:
    required: true
  -NewLocalPref UInt32: ~
  -NewMED UInt32: ~
  -NewNextHop IPAddress: ~
  -PassThru Switch: ~
  -PolicyType PolicyType:
    values:
    - Deny
    - Allow
    - ModifyAttribute
  -RemoveAllCommunities Switch: ~
  -RemoveCommunity String[]: ~
  -RemovePolicyClause String[]: ~
  -RoutingDomain,-RoutingDomainName String: ~
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
