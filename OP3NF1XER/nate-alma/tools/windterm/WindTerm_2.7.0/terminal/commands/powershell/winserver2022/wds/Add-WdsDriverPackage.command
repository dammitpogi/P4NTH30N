description: Adds an existing driver package to a driver group or injects it into
  a boot image
synopses:
- Add-WdsDriverPackage -Id <Guid> -GroupName <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Add-WdsDriverPackage -Id <Guid> -Architecture <Architecture> [-FileName <String>]
  -ImageName <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Add-WdsDriverPackage -Architecture <Architecture> [-FileName <String>] -ImageName
  <String> -Name <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Add-WdsDriverPackage -GroupName <String> -Name <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
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
  -FileName String: ~
  -GroupName String:
    required: true
  -Id Guid:
    required: true
  -ImageName String:
    required: true
  -Name String:
    required: true
  -ThrottleLimit Int32: ~
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
