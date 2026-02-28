description: Turns off the identification LED on a storage enclosure or the slots
  for individual disks
synopses:
- Disable-StorageEnclosureIdentification [-FriendlyName] <String[]> [-SlotNumbers
  <UInt32[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [<CommonParameters>]
- Disable-StorageEnclosureIdentification -UniqueId <String[]> [-SlotNumbers <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Disable-StorageEnclosureIdentification -InputObject <CimInstance[]> [-SlotNumbers
  <UInt32[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FriendlyName String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -SlotNumbers UInt32[]: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]:
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
