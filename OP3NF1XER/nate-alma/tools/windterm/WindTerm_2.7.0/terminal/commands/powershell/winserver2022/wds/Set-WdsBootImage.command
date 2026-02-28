description: Modifies settings of a boot image
synopses:
- Set-WdsBootImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] -ImageName <String> -Architecture <Architecture> [-FileName <String>]
  [-StopMulticastTransmission] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsBootImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] -ImageName <String> -Architecture <Architecture> [-FileName <String>]
  [-Multicast] [-TransmissionName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsBootImage [-NewImageName <String>] [-NewDescription <String>] [-DisplayOrder
  <UInt32>] -ImageName <String> -Architecture <Architecture> [-FileName <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Architecture Architecture:
    required: true
    values:
    - X86
    - Ia64
    - X64
    - Arm
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DisplayOrder UInt32: ~
  -FileName String: ~
  -Force Switch: ~
  -ImageName String:
    required: true
  -Multicast Switch:
    required: true
  -NewDescription String: ~
  -NewImageName String: ~
  -StopMulticastTransmission Switch:
    required: true
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
