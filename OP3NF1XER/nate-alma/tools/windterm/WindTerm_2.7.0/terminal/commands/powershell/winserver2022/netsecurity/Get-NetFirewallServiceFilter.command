description: Retrieves service filter objects from the target computer
synopses:
- Get-NetFirewallServiceFilter [-All] [-PolicyStore <String>] [-GPOSession <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallServiceFilter [-Service <String[]>] [-PolicyStore <String>] [-GPOSession
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallServiceFilter -AssociatedNetFirewallRule <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallRule CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -GPOSession String: ~
  -PolicyStore String: ~
  -Service String[]: ~
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
