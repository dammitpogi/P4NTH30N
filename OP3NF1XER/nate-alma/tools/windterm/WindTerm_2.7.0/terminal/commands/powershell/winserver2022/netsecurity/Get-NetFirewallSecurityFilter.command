description: Retrieves security filter objects from the target computer
synopses:
- Get-NetFirewallSecurityFilter [-All] [-PolicyStore <String>] [-GPOSession <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallSecurityFilter [-Authentication <Authentication[]>] [-Encryption
  <Encryption[]>] [-OverrideBlockRules <Boolean[]>] [-LocalUser <String[]>] [-RemoteUser
  <String[]>] [-RemoteMachine <String[]>] [-PolicyStore <String>] [-GPOSession <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallSecurityFilter -AssociatedNetFirewallRule <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallRule CimInstance:
    required: true
  -Authentication Authentication[]:
    values:
    - NotRequired
    - Required
    - NoEncap
  -CimSession,-Session CimSession[]: ~
  -Encryption Encryption[]:
    values:
    - NotRequired
    - Required
    - Dynamic
  -GPOSession String: ~
  -LocalUser String[]: ~
  -OverrideBlockRules Boolean[]: ~
  -PolicyStore String: ~
  -RemoteMachine String[]: ~
  -RemoteUser String[]: ~
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
