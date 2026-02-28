description: Sets the NAT64 configuration on a computer
synopses:
- Set-NetNatTransitionConfiguration [-InstanceName <String[]>] [-PolicyStore <PolicyStore[]>]
  [-Adapter <CimInstance>] [-State <State>] [-InboundInterface <String[]>] [-OutboundInterface
  <String[]>] [-PrefixMapping <String[]>] [-IPv4AddressPortPool <String[]>] [-TcpMappingTimeoutSeconds
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetNatTransitionConfiguration -InputObject <CimInstance[]> [-State <State>]
  [-InboundInterface <String[]>] [-OutboundInterface <String[]>] [-PrefixMapping <String[]>]
  [-IPv4AddressPortPool <String[]>] [-TcpMappingTimeoutSeconds <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Adapter CimInstance: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IPv4AddressPortPool String[]: ~
  -InboundInterface String[]: ~
  -InputObject CimInstance[]:
    required: true
  -InstanceName String[]: ~
  -OutboundInterface String[]: ~
  -PassThru Switch: ~
  -PolicyStore,-Store PolicyStore[]:
    values:
    - PersistentStore
    - ActiveStore
  -PrefixMapping String[]: ~
  -State State:
    values:
    - Disabled
    - Enabled
  -TcpMappingTimeoutSeconds,-TcpMappingTimeout UInt32: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
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
