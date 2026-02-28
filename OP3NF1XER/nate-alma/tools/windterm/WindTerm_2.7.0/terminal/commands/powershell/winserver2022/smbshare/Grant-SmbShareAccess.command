description: Adds an allow access control entry (ACE) for a trustee to the security
  descriptor of the Server Message Block (SMB) share
synopses:
- Grant-SmbShareAccess [-Name] <String[]> [[-ScopeName] <String[]>] [-SmbInstance
  <SmbInstance>] [-AccountName <String[]>] [-AccessRight <ShareAccessRight>] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Grant-SmbShareAccess -InputObject <CimInstance[]> [-AccountName <String[]>] [-AccessRight
  <ShareAccessRight>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessRight ShareAccessRight:
    values:
    - Full
    - Change
    - Read
  -AccountName String[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -ScopeName String[]: ~
  -SmbInstance SmbInstance:
    values:
    - Default
    - CSV
    - SBL
    - SR
  -ThrottleLimit Int32: ~
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
