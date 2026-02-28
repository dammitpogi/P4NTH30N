description: Validates a potential replication partnership
synopses:
- Test-SRTopology -SourceComputerName <String> -SourceVolumeName <String[]> -SourceLogVolumeName
  <String> -DestinationComputerName <String> -DestinationVolumeName <String[]> -DestinationLogVolumeName
  <String> -DurationInMinutes <UInt32> -ResultPath <String> [-IgnorePerfTests] [<CommonParameters>]
- Test-SRTopology [-GenerateReport] -DataPath <String> [<CommonParameters>]
options:
  -DataPath String:
    required: true
  -DestinationComputerName,-Destination String:
    required: true
  -DestinationLogVolumeName,-DestinationLogVolume String:
    required: true
  -DestinationVolumeName,-DestinationVolumes String[]:
    required: true
  -DurationInMinutes,-Duration UInt32:
    required: true
  -GenerateReport Switch:
    required: true
  -IgnorePerfTests Switch: ~
  -ResultPath,-OutputResultPath String:
    required: true
  -SourceComputerName,-Source String:
    required: true
  -SourceLogVolumeName,-SourceLogVolume String:
    required: true
  -SourceVolumeName,-SourceVolumes String[]:
    required: true
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
