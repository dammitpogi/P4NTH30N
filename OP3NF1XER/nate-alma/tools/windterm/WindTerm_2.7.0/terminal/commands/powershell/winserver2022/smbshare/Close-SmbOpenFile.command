description: Closes a file that is open by one of the clients of the SMB server
synopses:
- Close-SmbOpenFile [[-FileId] <UInt64[]>] [-SessionId <UInt64[]>] [-ClientComputerName
  <String[]>] [-ClientUserName <String[]>] [-ScopeName <String[]>] [-ClusterNodeName
  <String[]>] [-SmbInstance <SmbInstance>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Close-SmbOpenFile -InputObject <CimInstance[]> [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientComputerName String[]: ~
  -ClientUserName String[]: ~
  -ClusterNodeName String[]: ~
  -FileId UInt64[]: ~
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -ScopeName String[]: ~
  -SessionId UInt64[]: ~
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
