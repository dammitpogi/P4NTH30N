description: Creates a replication group
synopses:
- New-SRGroup [[-ComputerName] <String>] [-Name] <String> [-VolumeName] <String[]>
  [-LogVolumeName] <String> [[-LogSizeInBytes] <UInt64>] [[-Description] <String>]
  [-EnableConsistencyGroups] [-EnableEncryption] [-Force] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-CN String: ~
  -Description,-D String: ~
  -EnableConsistencyGroups,-EC Switch: ~
  -EnableEncryption,-EE Switch: ~
  -Force,-F Switch: ~
  -LogSizeInBytes,-LS UInt64: ~
  -LogVolumeName,-LV String:
    required: true
  -Name,-N String:
    required: true
  -ThrottleLimit Int32: ~
  -VolumeName,-VN String[]:
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
