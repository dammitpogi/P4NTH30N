description: Sets the various checksum offload settings
synopses:
- Set-NetAdapterChecksumOffload [-Name] <String[]> [-IncludeHidden] [-IpIPv4Enabled
  <Direction>] [-TcpIPv4Enabled <Direction>] [-TcpIPv6Enabled <Direction>] [-UdpIPv4Enabled
  <Direction>] [-UdpIPv6Enabled <Direction>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterChecksumOffload -InterfaceDescription <String[]> [-IncludeHidden]
  [-IpIPv4Enabled <Direction>] [-TcpIPv4Enabled <Direction>] [-TcpIPv6Enabled <Direction>]
  [-UdpIPv4Enabled <Direction>] [-UdpIPv6Enabled <Direction>] [-NoRestart] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-NetAdapterChecksumOffload -InputObject <CimInstance[]> [-IpIPv4Enabled <Direction>]
  [-TcpIPv4Enabled <Direction>] [-TcpIPv6Enabled <Direction>] [-UdpIPv4Enabled <Direction>]
  [-UdpIPv6Enabled <Direction>] [-NoRestart] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -IpIPv4Enabled Direction:
    values:
    - Disabled
    - TxEnabled
    - RxEnabled
    - RxTxEnabled
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -PassThru Switch: ~
  -TcpIPv4Enabled Direction:
    values:
    - Disabled
    - TxEnabled
    - RxEnabled
    - RxTxEnabled
  -TcpIPv6Enabled Direction:
    values:
    - Disabled
    - TxEnabled
    - RxEnabled
    - RxTxEnabled
  -ThrottleLimit Int32: ~
  -UdpIPv4Enabled Direction:
    values:
    - Disabled
    - TxEnabled
    - RxEnabled
    - RxTxEnabled
  -UdpIPv6Enabled Direction:
    values:
    - Disabled
    - TxEnabled
    - RxEnabled
    - RxTxEnabled
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
