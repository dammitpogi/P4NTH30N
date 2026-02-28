description: Gets a list of clients connected to a multicast transmission or namespace
synopses:
- Get-WdsMulticastClient [-FileName <String>] [-ImageGroup <String>] -InstallImageName
  <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-WdsMulticastClient [-FileName <String>] -Architecture <BootImageArchitecture>
  -BootImageName <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-WdsMulticastClient -BootImageObject <CimInstance> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-WdsMulticastClient -InstallImageObject <CimInstance> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-WdsMulticastClient [-TransmissionName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Architecture BootImageArchitecture:
    required: true
    values:
    - Unknown
    - X86
    - Ia64
    - X64
    - Arm
  -AsJob Switch: ~
  -BootImageName String:
    required: true
  -BootImageObject CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -FileName String: ~
  -ImageGroup String: ~
  -InstallImageName String:
    required: true
  -InstallImageObject CimInstance:
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
