description: Creates a fault domain in the cluster
synopses:
- New-ClusterFaultDomain -Name <String> [-FaultDomain <String>] -FaultDomainType <FaultDomainType>
  [-Description <String>] [-Location <String>] [-Flags <UInt32>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Description String: ~
  -FaultDomain,-Parent String: ~
  -FaultDomainType,-Type FaultDomainType:
    required: true
    values:
    - Site
    - Rack
    - Chassis
    - Node
  -Flags UInt32: ~
  -Location String: ~
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
