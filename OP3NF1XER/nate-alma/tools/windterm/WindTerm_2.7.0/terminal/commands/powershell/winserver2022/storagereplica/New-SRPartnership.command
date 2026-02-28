description: Creates a replication partnership between two replication groups
synopses:
- New-SRPartnership [[-SourceComputerName] <String>] [-SourceRGName] <String> [-DestinationComputerName]
  <String> [-DestinationRGName] <String> [[-ReplicationMode] <ReplicationMode>] [-PreventReplication]
  [-Seeded] [[-AsyncRPO] <UInt32>] [-EnableEncryption] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-SRPartnership [[-SourceComputerName] <String>] [-SourceRGName] <String> [-SourceVolumeName]
  <String[]> [-SourceLogVolumeName] <String> [[-SourceRGDescription] <String>] [-DestinationComputerName]
  <String> [-DestinationRGName] <String> [-DestinationVolumeName] <String[]> [-DestinationLogVolumeName]
  <String> [[-DestinationRGDescription] <String>] [[-ReplicationMode] <ReplicationMode>]
  [[-LogSizeInBytes] <UInt64>] [-PreventReplication] [-Seeded] [-EnableConsistencyGroups]
  [[-AsyncRPO] <UInt32>] [-EnableEncryption] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AsyncRPO,-RPO UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -DestinationComputerName,-DCN String:
    required: true
  -DestinationLogVolumeName,-DLV String:
    required: true
  -DestinationRGDescription,-DGD String: ~
  -DestinationRGName,-DGN String:
    required: true
  -DestinationVolumeName,-DVN String[]:
    required: true
  -EnableConsistencyGroups,-EC Switch: ~
  -EnableEncryption,-EE Switch: ~
  -Force,-F Switch: ~
  -LogSizeInBytes,-LS UInt64: ~
  -PreventReplication,-P Switch: ~
  -ReplicationMode,-RM ReplicationMode:
    values:
    - Synchronous
    - Asynchronous
  -Seeded,-S Switch: ~
  -SourceComputerName,-SCN String: ~
  -SourceLogVolumeName,-SLN String:
    required: true
  -SourceRGDescription,-SGD String: ~
  -SourceRGName,-SGN String:
    required: true
  -SourceVolumeName,-SVN String[]:
    required: true
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
