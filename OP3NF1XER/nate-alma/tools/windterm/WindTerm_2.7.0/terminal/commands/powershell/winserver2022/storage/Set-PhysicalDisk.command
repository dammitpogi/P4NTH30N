description: Sets attributes on a specific physical disk
synopses:
- Set-PhysicalDisk [-NewFriendlyName <String>] [-Description <String>] [-Usage <Usage>]
  [-MediaType <MediaType>] -UniqueId <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-PhysicalDisk -InputObject <CimInstance[]> [-NewFriendlyName <String>] [-Description
  <String>] [-Usage <Usage>] [-MediaType <MediaType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-PhysicalDisk [-NewFriendlyName <String>] [-Description <String>] [-Usage <Usage>]
  [-MediaType <MediaType>] [-FriendlyName] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Description String: ~
  -FriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -MediaType MediaType:
    values:
    - HDD
    - SSD
    - SCM
  -NewFriendlyName String: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String:
    required: true
  -Usage Usage:
    values:
    - AutoSelect
    - ManualSelect
    - HotSpare
    - Retired
    - Journal
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
