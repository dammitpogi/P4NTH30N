description: Gets information about the Network Load Balancing (NLB) driver on the
  local machine
synopses:
- Get-NlbClusterDriverInfo [-InterfaceName <String>] [-Params] [<CommonParameters>]
- Get-NlbClusterDriverInfo [-InterfaceName <String>] -Filter <Protocol> -ClientIP
  <IPAddress> [-ClientPort <Int32>] -ServerIP <IPAddress> [-ServerPort <Int32>] [-Flags
  <Flags>] [<CommonParameters>]
- Get-NlbClusterDriverInfo [-InterfaceName <String>] [-ConvergenceHistory] [<CommonParameters>]
- Get-NlbClusterDriverInfo [-InterfaceName <String>] [-ExtendedAffinityList] [<CommonParameters>]
- Get-NlbClusterDriverInfo [-InterfaceName <String>] [-ExtendedAffinityExceptionList]
  [<CommonParameters>]
- Get-NlbClusterDriverInfo [-InterfaceName <String>] [-OpenConnections] [<CommonParameters>]
options:
  -ClientIP,-CIP IPAddress:
    required: true
  -ClientPort,-CPT Int32: ~
  -ConvergenceHistory,-History Switch:
    required: true
  -ExtendedAffinityExceptionList,-ExceptionList Switch:
    required: true
  -ExtendedAffinityList Switch:
    required: true
  -Filter Protocol:
    required: true
    values:
    - Tcp
    - Pptp
    - Gre
    - Udp
    - Ipsec
    - Icmp
  -Flags,-FG Flags:
    values:
    - Syn
    - Fin
    - Rst
  -InterfaceName String: ~
  -OpenConnections,-OpenConnection Switch:
    required: true
  -Params Switch: ~
  -ServerIP,-SIP IPAddress:
    required: true
  -ServerPort,-SPT Int32: ~
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
