description: Retrieves information about the SMB sessions that are currently established
  between the SMB server and the associated clients
synopses:
- Get-SmbSession [[-SessionId] <UInt64[]>] [[-ClientComputerName] <String[]>] [[-ClientUserName]
  <String[]>] [[-ScopeName] <String[]>] [[-ClusterNodeName] <String[]>] [-IncludeHidden]
  [-SmbInstance <SmbInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientComputerName String[]: ~
  -ClientUserName String[]: ~
  -ClusterNodeName String[]: ~
  -IncludeHidden Switch: ~
  -ScopeName String[]: ~
  -SessionId UInt64[]: ~
  -SmbInstance SmbInstance:
    values:
    - Default
    - CSV
    - SBL
    - SR
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
