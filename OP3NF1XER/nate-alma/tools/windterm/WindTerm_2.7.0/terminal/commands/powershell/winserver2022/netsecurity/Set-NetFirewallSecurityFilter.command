description: Modifies security filter objects, thereby modifying the Authentication,
  Encryption, OverrideBlockRules, LocalUser, RemoteUser, and RemoteMachine conditions
  of the firewall rules
synopses:
- Set-NetFirewallSecurityFilter [-PolicyStore <String>] [-GPOSession <String>] [-Authentication
  <Authentication>] [-Encryption <Encryption>] [-OverrideBlockRules <Boolean>] [-LocalUser
  <String>] [-RemoteUser <String>] [-RemoteMachine <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetFirewallSecurityFilter -InputObject <CimInstance[]> [-Authentication <Authentication>]
  [-Encryption <Encryption>] [-OverrideBlockRules <Boolean>] [-LocalUser <String>]
  [-RemoteUser <String>] [-RemoteMachine <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Authentication Authentication:
    values:
    - NotRequired
    - Required
    - NoEncap
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Encryption Encryption:
    values:
    - NotRequired
    - Required
    - Dynamic
  -GPOSession String: ~
  -InputObject CimInstance[]:
    required: true
  -LocalUser String: ~
  -OverrideBlockRules Boolean: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -RemoteMachine String: ~
  -RemoteUser String: ~
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
