description: Displays settings that apply to the per-profile configurations of the
  Windows Firewall with Advanced Security
synopses:
- Get-NetFirewallProfile [-All] [-PolicyStore <String>] [-GPOSession <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallProfile [-Name] <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallProfile -AssociatedNetFirewallRule <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetFirewallProfile -AssociatedNetIPsecRule <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetFirewallProfile -AssociatedNetIPsecMainModeRule <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallRule CimInstance:
    required: true
  -AssociatedNetIPsecMainModeRule CimInstance:
    required: true
  -AssociatedNetIPsecRule CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -GPOSession String: ~
  -Name,-Profile String[]:
    required: true
  -PolicyStore String: ~
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
