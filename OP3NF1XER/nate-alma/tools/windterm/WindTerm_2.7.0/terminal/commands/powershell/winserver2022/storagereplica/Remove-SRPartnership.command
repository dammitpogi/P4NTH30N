description: Removes a replication partnership
synopses:
- Remove-SRPartnership [[-SourceComputerName] <String>] [-SourceRGName] <String> [-DestinationComputerName]
  <String> [-DestinationRGName] <String> [-ApplyChanges] [-IgnoreRemovalFailure] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -ApplyChanges,-ADA Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DestinationComputerName,-DCN String:
    required: true
  -DestinationRGName,-DGN String:
    required: true
  -Force,-F Switch: ~
  -IgnoreRemovalFailure,-IRF Switch: ~
  -SourceComputerName,-SCN String: ~
  -SourceRGName,-SGN String:
    required: true
  -ThrottleLimit Int32: ~
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
