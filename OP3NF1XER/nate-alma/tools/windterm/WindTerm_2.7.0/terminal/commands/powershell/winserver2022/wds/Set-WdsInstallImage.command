description: Modifies the properties of an install image
synopses:
- Set-WdsInstallImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-UserFilter <String>] [-UnattendFile <String>] [-OverwriteUnattend] [-ImageGroup
  <String>] [-FileName <String>] -ImageName <String> [-StopMulticastTransmission]
  [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsInstallImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-UserFilter <String>] [-UnattendFile <String>] [-OverwriteUnattend] [-ImageGroup
  <String>] [-FileName <String>] -ImageName <String> [-StartScheduledCast] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsInstallImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-UserFilter <String>] [-UnattendFile <String>] [-OverwriteUnattend] [-ImageGroup
  <String>] [-FileName <String>] -ImageName <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsInstallImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-UserFilter <String>] [-UnattendFile <String>] [-OverwriteUnattend] [-ImageGroup
  <String>] [-FileName <String>] -ImageName <String> [-Multicast] [-TransmissionName
  <String>] [-ManualStart] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-WdsInstallImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] [-UserFilter <String>] [-UnattendFile <String>] [-OverwriteUnattend] [-ImageGroup
  <String>] [-FileName <String>] [-ClientCount <UInt32>] [-StartTime <DateTime>] -ImageName
  <String> [-Multicast] [-TransmissionName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientCount UInt32: ~
  -DisplayOrder UInt32: ~
  -FileName String: ~
  -Force Switch: ~
  -ImageGroup String: ~
  -ImageName String:
    required: true
  -ManualStart Switch:
    required: true
  -Multicast Switch:
    required: true
  -NewDescription String: ~
  -NewImageName String: ~
  -OverwriteUnattend Switch: ~
  -StartScheduledCast Switch:
    required: true
  -StartTime DateTime: ~
  -StopMulticastTransmission Switch:
    required: true
  -ThrottleLimit Int32: ~
  -TransmissionName String: ~
  -UnattendFile String: ~
  -UserFilter String: ~
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
