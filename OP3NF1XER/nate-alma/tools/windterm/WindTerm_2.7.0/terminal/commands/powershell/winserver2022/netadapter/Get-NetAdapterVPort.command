description: Displays the network adapter VPort settings for a SR-IOV or VMQ VPort
synopses:
- Get-NetAdapterVPort [[-Name] <String[]>] [-VPortID <UInt32[]>] [-SwitchID <UInt32[]>]
  [-FunctionID <UInt16[]>] [-PhysicalFunction] [-IncludeHidden] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetAdapterVPort -InterfaceDescription <String[]> [-VPortID <UInt32[]>] [-SwitchID
  <UInt32[]>] [-FunctionID <UInt16[]>] [-PhysicalFunction] [-IncludeHidden] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FunctionID,-VfID UInt16[]: ~
  -IncludeHidden Switch: ~
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
  -PhysicalFunction,-PF Switch: ~
  -SwitchID UInt32[]: ~
  -ThrottleLimit Int32: ~
  -VPortID,-Id UInt32[]: ~
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
