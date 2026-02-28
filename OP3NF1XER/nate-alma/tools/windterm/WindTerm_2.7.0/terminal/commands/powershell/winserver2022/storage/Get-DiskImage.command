description: Gets one or more disk image objects (virtual hard disk or ISO)
synopses:
- Get-DiskImage [-ImagePath] <String[]> [-StorageType <StorageType>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DiskImage [-Volume <CimInstance>] [-StorageType <StorageType>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DiskImage -DevicePath <String[]> [-StorageType <StorageType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DevicePath String[]:
    required: true
  -ImagePath String[]:
    required: true
  -StorageType StorageType:
    values:
    - Unknown
    - ISO
    - VHD
    - VHDX
    - VHDSet
  -ThrottleLimit Int32: ~
  -Volume CimInstance: ~
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
