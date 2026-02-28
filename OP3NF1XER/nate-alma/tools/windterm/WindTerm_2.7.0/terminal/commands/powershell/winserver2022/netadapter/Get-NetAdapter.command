description: Gets the basic network adapter properties
synopses:
- powershell Get-NetAdapter [[-Name] <String[]>] [-IncludeHidden] [-Physical] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- powershell Get-NetAdapter -InterfaceDescription <String[]> [-IncludeHidden] [-Physical]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- powershell Get-NetAdapter -InterfaceIndex <UInt32[]> [-IncludeHidden] [-Physical]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -IncludeHidden Switch: ~
  -InterfaceDescription,-ifDesc String[]:
    required: true
  -InterfaceIndex,-ifIndex UInt32[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
  -Physical Switch: ~
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
