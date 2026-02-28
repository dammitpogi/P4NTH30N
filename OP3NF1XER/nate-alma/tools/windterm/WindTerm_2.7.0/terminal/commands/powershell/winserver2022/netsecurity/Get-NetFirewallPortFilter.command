description: Retrieves port filter objects from the target computer
synopses:
- Get-NetFirewallPortFilter [-All] [-PolicyStore <String>] [-GPOSession <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallPortFilter [-Protocol <String[]>] [-DynamicTarget <DynamicTransport[]>]
  [-PolicyStore <String>] [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallPortFilter -AssociatedNetFirewallRule <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallPortFilter -AssociatedNetIPsecRule <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallRule CimInstance:
    required: true
  -AssociatedNetIPsecRule CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -DynamicTarget,-DynamicTransport DynamicTransport[]:
    values:
    - Any
    - ProximityApps
    - ProximitySharing
    - WifiDirectPrinting
    - WifiDirectDisplay
    - WifiDirectDevices
  -GPOSession String: ~
  -PolicyStore String: ~
  -Protocol String[]: ~
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
