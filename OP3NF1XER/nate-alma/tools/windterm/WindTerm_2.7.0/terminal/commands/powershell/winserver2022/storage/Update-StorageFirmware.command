description: Updates the firmware on a storage device
synopses:
- Update-StorageFirmware [-FriendlyName] <String> [-ImagePath <String>] [-SlotNumber
  <UInt16>] [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Update-StorageFirmware -UniqueId <String> [-ImagePath <String>] [-SlotNumber <UInt16>]
  [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Update-StorageFirmware -InputObject <CimInstance[]> [-ImagePath <String>] [-SlotNumber
  <UInt16>] [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -FriendlyName String:
    required: true
  -ImagePath String: ~
  -InputObject CimInstance[]:
    required: true
  -SlotNumber UInt16: ~
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
