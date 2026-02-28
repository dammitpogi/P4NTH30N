description: Imports an install image to an image store
synopses:
- Import-WdsInstallImage [-SkipVerify] [-ImageGroup <String>] [-DisplayOrder <UInt32>]
  [-UnattendFile <String>] -Path <String> [-NewImageName <String>] [-NewDescription
  <String>] [-NewFileName <String>] [-ImageName <String>] [-TransmissionName <String>]
  [-Multicast] [-ManualStart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Import-WdsInstallImage [-SkipVerify] [-ImageGroup <String>] [-DisplayOrder <UInt32>]
  [-UnattendFile <String>] -Path <String> [-NewImageName <String>] [-NewDescription
  <String>] [-NewFileName <String>] [-ImageName <String>] [-ClientCount <UInt32>]
  [-StartTime <DateTime>] [-TransmissionName <String>] [-Multicast] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Import-WdsInstallImage [-SkipVerify] [-ImageGroup <String>] [-DisplayOrder <UInt32>]
  [-UnattendFile <String>] -Path <String> [-NewImageName <String>] [-NewDescription
  <String>] [-NewFileName <String>] [-ImageName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientCount UInt32: ~
  -DisplayOrder UInt32: ~
  -ImageGroup String: ~
  -ImageName String: ~
  -ManualStart Switch:
    required: true
  -Multicast Switch:
    required: true
  -NewDescription String: ~
  -NewFileName String: ~
  -NewImageName String: ~
  -Path String:
    required: true
  -SkipVerify Switch: ~
  -StartTime DateTime: ~
  -ThrottleLimit Int32: ~
  -TransmissionName String: ~
  -UnattendFile String: ~
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
