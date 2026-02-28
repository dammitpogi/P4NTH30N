description: Specifies Server Message Block (SMB) leasing and oplock behaviors
synopses:
- New-SmbGlobalMapping [[-LocalPath] <String>] [-RemotePath] <String> -Credential
  <PSCredential> [-Persistent <Boolean>] [-RequireIntegrity <Boolean>] [-RequirePrivacy
  <Boolean>] [-UseWriteThrough <Boolean>] [-FullAccess <String[]>] [-DenyAccess <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Credential PSCredential:
    required: true
  -DenyAccess String[]: ~
  -FullAccess String[]: ~
  -LocalPath String: ~
  -Persistent Boolean: ~
  -RemotePath String:
    required: true
  -RequireIntegrity Boolean: ~
  -RequirePrivacy Boolean: ~
  -ThrottleLimit Int32: ~
  -UseWriteThrough Boolean: ~
  -Confirm,-cf Switch: ~
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
