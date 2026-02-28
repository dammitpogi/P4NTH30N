description: Creates or modifies a replication network constraint for servers and
  partnerships
synopses:
- Set-SRNetworkConstraint [[-SourceComputerName] <String>] [[-SourceRGName] <String>]
  [-SourceNWInterface] <String[]> [[-DestinationComputerName] <String>] [[-DestinationRGName]
  <String>] [-DestinationNWInterface] <String[]> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DestinationComputerName,-DCN String: ~
  -DestinationNWInterface,-DNI String[]:
    required: true
  -DestinationRGName,-DGN String: ~
  -SourceComputerName,-SCN String: ~
  -SourceNWInterface,-SNI String[]:
    required: true
  -SourceRGName,-SGN String: ~
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
