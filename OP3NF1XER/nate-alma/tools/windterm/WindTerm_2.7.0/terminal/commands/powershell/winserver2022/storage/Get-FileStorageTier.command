description: Gets the files assigned to a Storage tier on a volume, and their status
synopses:
- Get-FileStorageTier -VolumeDriveLetter <Char> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-FileStorageTier -VolumePath <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-FileStorageTier -Volume <CimInstance> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-FileStorageTier -FilePath <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FilePath String:
    required: true
  -ThrottleLimit Int32: ~
  -Volume CimInstance:
    required: true
  -VolumeDriveLetter Char:
    required: true
  -VolumePath String:
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
