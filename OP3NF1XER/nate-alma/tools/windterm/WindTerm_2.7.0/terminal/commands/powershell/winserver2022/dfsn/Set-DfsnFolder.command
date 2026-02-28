description: Changes settings for a DFS namespace folder
synopses:
- Set-DfsnFolder [-Path] <String> [[-EnableInsiteReferrals] <Boolean>] [[-EnableTargetFailback]
  <Boolean>] [[-State] <State>] [[-TimeToLiveSec] <UInt32>] [[-Description] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description,-desc String: ~
  -EnableInsiteReferrals,-insite Boolean: ~
  -EnableTargetFailback,-failback,-TargetFailback Boolean: ~
  -Path,-DfsPath,-FolderPath,-NamespacePath String:
    required: true
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
