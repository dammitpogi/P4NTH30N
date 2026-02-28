description: Sends ICMP echo request packets, or pings, to one or more computers
synopses:
- Test-Connection [-TargetName] <string[]> [-Ping] [-IPv4] [-IPv6] [-ResolveDestination]
  [-Source <string>] [-MaxHops <int>] [-Count <int>] [-Delay <int>] [-BufferSize <int>]
  [-DontFragment] [-TimeoutSeconds <int>] [-Quiet] [<CommonParameters>]
- Test-Connection [-TargetName] <string[]> -Repeat [-Ping] [-IPv4] [-IPv6] [-ResolveDestination]
  [-Source <string>] [-MaxHops <int>] [-Delay <int>] [-BufferSize <int>] [-DontFragment]
  [-TimeoutSeconds <int>] [-Quiet] [<CommonParameters>]
- Test-Connection [-TargetName] <string[]> -MtuSize [-IPv4] [-IPv6] [-ResolveDestination]
  [-TimeoutSeconds <int>] [-Quiet] [<CommonParameters>]
- Test-Connection [-TargetName] <string[]> -Traceroute [-IPv4] [-IPv6] [-ResolveDestination]
  [-Source <string>] [-MaxHops <int>] [-TimeoutSeconds <int>] [-Quiet] [<CommonParameters>]
- Test-Connection [-TargetName] <string[]> -TcpPort <int> [-IPv4] [-IPv6] [-ResolveDestination]
  [-Source <string>] [-TimeoutSeconds <int>] [-Quiet] [<CommonParameters>]
options:
  -BufferSize,-Size,-Bytes,-BS System.Int32: ~
  -Count System.Int32: ~
  -Delay System.Int32: ~
  -DontFragment Switch: ~
  -IPv4 Switch: ~
  -IPv6 Switch: ~
  -MaxHops,-Ttl,-TimeToLive,-Hops System.Int32: ~
  -MtuSize,-MtuSizeDetect Switch:
    required: true
  -Ping Switch: ~
  -Quiet Switch: ~
  -Repeat,-Continuous Switch:
    required: true
  -ResolveDestination Switch: ~
  -Source System.String: ~
  -TargetName,-ComputerName System.String[]:
    required: true
  -TcpPort System.Int32:
    required: true
  -TimeoutSeconds System.Int32: ~
  -Traceroute Switch:
    required: true
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
