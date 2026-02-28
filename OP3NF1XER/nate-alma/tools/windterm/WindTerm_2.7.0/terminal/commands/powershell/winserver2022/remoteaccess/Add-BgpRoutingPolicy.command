description: Adds a BGP routing policy to the policy store
synopses:
- Add-BgpRoutingPolicy [-PassThru] [-RoutingDomain <String>] [-IgnorePrefix <String[]>]
  [-Name] <String> [-MatchCommunity <String[]>] [-NewLocalPref <UInt32>] [-AddCommunity
  <String[]>] [-Force] [-NewMED <UInt32>] [-PolicyType] <PolicyType> [-NewNextHop
  <IPAddress>] [-RemoveCommunity <String[]>] [-MatchPrefix <String[]>] [-MatchNextHop
  <IPAddress[]>] [-MatchASNRange <UInt32[]>] [-ClearMED] [-RemoveAllCommunities] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AddCommunity String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClearMED Switch: ~
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
    required: true
    values:
    - Deny
    - Allow
    - ModifyAttribute
  -RemoveAllCommunities Switch: ~
  -RemoveCommunity String[]: ~
  -RoutingDomain,-RoutingDomainName String: ~
  -ThrottleLimit Int32: ~
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
