description: Displays the SR-IOV virtual function settings for a network adapter
synopses:
- Get-NetAdapterSriovVf [[-Name] <String[]>] [-SwitchID <UInt32[]>] [-FunctionID <UInt16[]>]
  [-IncludeHidden] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetAdapterSriovVf -InterfaceDescription <String[]> [-SwitchID <UInt32[]>] [-FunctionID
  <UInt16[]>] [-IncludeHidden] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FunctionID,-VfID,-Id UInt16[]: ~
  -IncludeHidden Switch: ~
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
  -SwitchID UInt32[]: ~
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
