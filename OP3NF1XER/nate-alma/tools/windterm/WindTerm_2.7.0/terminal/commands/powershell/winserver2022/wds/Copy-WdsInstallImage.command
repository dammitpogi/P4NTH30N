description: Copies install images within an image group
synopses:
- Copy-WdsInstallImage [-NewDescription <String>] [-ImageGroup <String>] [-FileName
  <String>] -ImageName <String> -NewFileName <String> -NewImageName <String> [-TransmissionName
  <String>] [-Multicast] [-ManualStart] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Copy-WdsInstallImage [-NewDescription <String>] [-ImageGroup <String>] [-FileName
  <String>] -ImageName <String> -NewFileName <String> -NewImageName <String> [-StartTime
  <DateTime>] [-ClientCount <UInt32>] [-TransmissionName <String>] [-Multicast] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Copy-WdsInstallImage [-NewDescription <String>] [-ImageGroup <String>] [-FileName
  <String>] -ImageName <String> -NewFileName <String> -NewImageName <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientCount UInt32: ~
  -FileName String: ~
  -ImageGroup String: ~
  -ImageName String:
    required: true
  -ManualStart Switch:
    required: true
  -Multicast Switch:
    required: true
  -NewDescription String: ~
  -NewFileName String:
    required: true
  -NewImageName String:
    required: true
  -StartTime DateTime: ~
  -ThrottleLimit Int32: ~
  -TransmissionName String: ~
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
