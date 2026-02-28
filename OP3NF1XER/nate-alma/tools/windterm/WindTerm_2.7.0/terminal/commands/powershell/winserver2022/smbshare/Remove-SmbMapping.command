description: Removes the SMB mapping to an SMB share
synopses:
- Remove-SmbMapping [[-LocalPath] <String[]>] [[-RemotePath] <String[]>] [-UpdateProfile]
  [-Force] [-GlobalMapping] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-SmbMapping -InputObject <CimInstance[]> [-UpdateProfile] [-Force] [-GlobalMapping]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Force Switch: ~
  -GlobalMapping Switch: ~
  -InputObject CimInstance[]:
    required: true
  -LocalPath String[]: ~
  -PassThru Switch: ~
  -RemotePath String[]: ~
  -ThrottleLimit Int32: ~
  -UpdateProfile Switch: ~
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
