description: Creates an SMB mapping
synopses:
- New-SmbMapping [[-LocalPath] <String>] [[-RemotePath] <String>] [-UserName <String>]
  [-Password <String>] [-Persistent <Boolean>] [-SaveCredentials] [-HomeFolder] [-RequireIntegrity
  <Boolean>] [-RequirePrivacy <Boolean>] [-UseWriteThrough <Boolean>] [-TransportType
  <TransportType>] [-SkipCertificateCheck] [-CompressNetworkTraffic <Boolean>] [-GlobalMapping]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CompressNetworkTraffic Boolean: ~
  -GlobalMapping Switch: ~
  -HomeFolder Switch: ~
  -LocalPath String: ~
  -Password String: ~
  -Persistent Boolean: ~
  -RemotePath String: ~
  -RequireIntegrity Boolean: ~
  -RequirePrivacy Boolean: ~
  -SaveCredentials Switch: ~
  -SkipCertificateCheck Switch: ~
  -ThrottleLimit Int32: ~
  -TransportType TransportType: ~
  -UserName String: ~
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
