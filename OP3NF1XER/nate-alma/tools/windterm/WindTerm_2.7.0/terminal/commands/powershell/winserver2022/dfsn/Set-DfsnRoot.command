description: Changes settings for a DFS namespace
synopses:
- Set-DfsnRoot [-Path] <String> [[-EnableSiteCosting] <Boolean>] [[-EnableInsiteReferrals]
  <Boolean>] [[-EnableAccessBasedEnumeration] <Boolean>] [[-EnableRootScalability]
  <Boolean>] [[-EnableTargetFailback] <Boolean>] [[-Description] <String>] [[-State]
  <State>] [[-TimeToLiveSec] <UInt32>] [[-GrantAdminAccounts] <String[]>] [[-RevokeAdminAccounts]
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description,-desc String: ~
  -EnableAccessBasedEnumeration,-abe,-abde Boolean: ~
  -EnableInsiteReferrals,-insite Boolean: ~
  -EnableRootScalability,-RootScalability,-rootscale Boolean: ~
  -EnableSiteCosting,-SiteCosting,-sitecost Boolean: ~
  -EnableTargetFailback,-failback,-TargetFailback Boolean: ~
  -GrantAdminAccounts,-GrantAdmin,-GrantAdminAccess String[]: ~
  -Path,-RootPath,-root,-namespace,-NamespaceRoot String:
    required: true
  -RevokeAdminAccounts,-RevokeAdmin,-RevokeAdminAccess String[]: ~
  -State State:
    values:
    - Offline
    - Online
  -ThrottleLimit Int32: ~
  -TimeToLiveSec,-ttl,-TimeToLive UInt32: ~
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
