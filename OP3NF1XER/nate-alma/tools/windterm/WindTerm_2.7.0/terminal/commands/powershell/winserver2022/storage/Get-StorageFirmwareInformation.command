description: Gets information about firmware on a storage object
synopses:
- Get-StorageFirmwareInformation [-FriendlyName] <String> [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageFirmwareInformation -UniqueId <String> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageFirmwareInformation -InputObject <CimInstance[]> [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -FriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String:
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
