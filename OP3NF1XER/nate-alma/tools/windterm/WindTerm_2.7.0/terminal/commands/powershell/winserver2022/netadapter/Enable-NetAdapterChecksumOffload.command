description: Enables checksum offloads on the network adapter
synopses:
- Enable-NetAdapterChecksumOffload [-Name] <String[]> [-IncludeHidden] [-IpIPv4] [-TcpIPv4]
  [-TcpIPv6] [-UdpIPv4] [-UdpIPv6] [-NoRestart] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-NetAdapterChecksumOffload -InterfaceDescription <String[]> [-IncludeHidden]
  [-IpIPv4] [-TcpIPv4] [-TcpIPv6] [-UdpIPv4] [-UdpIPv6] [-NoRestart] [-PassThru] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-NetAdapterChecksumOffload -InputObject <CimInstance[]> [-IpIPv4] [-TcpIPv4]
  [-TcpIPv6] [-UdpIPv4] [-UdpIPv6] [-NoRestart] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -IpIPv4 Switch: ~
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -PassThru Switch: ~
  -TcpIPv4 Switch: ~
  -TcpIPv6 Switch: ~
  -ThrottleLimit Int32: ~
  -UdpIPv4 Switch: ~
  -UdpIPv6 Switch: ~
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
