description: Gets network adapters that support RSC
synopses:
- Get-NetAdapterRsc [[-Name] <String[]>] [-IPv4OperationalState <Boolean[]>] [-IPv6OperationalState
  <Boolean[]>] [-IPv4FailureReason <FailureReason[]>] [-IPv6FailureReason <FailureReason[]>]
  [-IncludeHidden] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetAdapterRsc -InterfaceDescription <String[]> [-IPv4OperationalState <Boolean[]>]
  [-IPv6OperationalState <Boolean[]>] [-IPv4FailureReason <FailureReason[]>] [-IPv6FailureReason
  <FailureReason[]>] [-IncludeHidden] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -IPv4FailureReason FailureReason[]:
    values:
    - NoFailure
    - NicPropertyDisabled
    - WFPCompatibility
    - NDISCompatibility
    - ForwardingEnabled
    - NetOffloadGlobalDisabled
    - Capability
    - Unknown
  -IPv4OperationalState Boolean[]: ~
  -IPv6FailureReason FailureReason[]:
    values:
    - NoFailure
    - NicPropertyDisabled
    - WFPCompatibility
    - NDISCompatibility
    - ForwardingEnabled
    - NetOffloadGlobalDisabled
    - Capability
    - Unknown
  -IPv6OperationalState Boolean[]: ~
  -IncludeHidden Switch: ~
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
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
