description: Modifies a replication partnership between two replication groups
synopses:
- Set-SRPartnership [[-SourceComputerName] <String>] [-SourceRGName] <String> [-SourceAddVolumePartnership]
  <String[]> [-DestinationComputerName] <String> [-DestinationRGName] <String> [-DestinationAddVolumePartnership]
  <String[]> [-Seeded] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-SRPartnership [[-SourceComputerName] <String>] [-SourceRGName] <String> [-DestinationComputerName]
  <String> [-DestinationRGName] <String> [[-ReplicationMode] <ReplicationMode>] [[-LogSizeInBytes]
  <UInt64>] [[-AsyncRPO] <UInt32>] [[-Encryption] <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-SRPartnership [-SourceRGName] <String> [-DestinationComputerName] <String> [-DestinationRGName]
  <String> [-Force] [[-NewSourceComputerName] <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AsyncRPO,-RPO UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DestinationAddVolumePartnership,-DAV String[]:
    required: true
  -DestinationComputerName,-DCN String:
    required: true
  -DestinationRGName,-DGN String:
    required: true
  -Encryption,-ENC Boolean: ~
  -Force,-F Switch: ~
  -LogSizeInBytes,-LS UInt64: ~
  -NewSourceComputerName,-NSCN String: ~
  -ReplicationMode,-RM ReplicationMode:
    values:
    - Synchronous
    - Asynchronous
  -Seeded,-S Switch: ~
  -SourceAddVolumePartnership,-SAV String[]:
    required: true
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
