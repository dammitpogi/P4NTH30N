description: Creates a new snapshot of the specified virtual disk
synopses:
- New-VirtualDiskSnapshot -VirtualDiskUniqueId <String[]> -FriendlyName <String> [-TargetStoragePoolName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-VirtualDiskSnapshot [-VirtualDiskFriendlyName] <String[]> -FriendlyName <String>
  [-TargetStoragePoolName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-VirtualDiskSnapshot -VirtualDiskName <String[]> -FriendlyName <String> [-TargetStoragePoolName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-VirtualDiskSnapshot -InputObject <CimInstance[]> -FriendlyName <String> [-TargetStoragePoolName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -TargetStoragePoolName String: ~
  -ThrottleLimit Int32: ~
  -VirtualDiskFriendlyName String[]:
    required: true
  -VirtualDiskName String[]:
    required: true
  -VirtualDiskUniqueId,-VirtualDiskId String[]:
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
