description: Creates a new inbound or outbound firewall rule and adds the rule to
  the target computer
synopses:
- New-NetFirewallRule [-PolicyStore <String>] [-GPOSession <String>] [-Name <String>]
  -DisplayName <String> [-Description <String>] [-Group <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-Direction <Direction>] [-Action <Action>]
  [-EdgeTraversalPolicy <EdgeTraversal>] [-LooseSourceMapping <Boolean>] [-LocalOnlyMapping
  <Boolean>] [-Owner <String>] [-LocalAddress <String[]>] [-RemoteAddress <String[]>]
  [-Protocol <String>] [-LocalPort <String[]>] [-RemotePort <String[]>] [-IcmpType
  <String[]>] [-DynamicTarget <DynamicTransport>] [-Program <String>] [-Package <String>]
  [-Service <String>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>]
  [-LocalUser <String>] [-RemoteUser <String>] [-RemoteMachine <String>] [-Authentication
  <Authentication>] [-Encryption <Encryption>] [-OverrideBlockRules <Boolean>] [-RemoteDynamicKeywordAddresses
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Action Action:
    values:
    - NotConfigured
    - Allow
    - Block
  -AsJob Switch: ~
  -Authentication Authentication:
    values:
    - NotRequired
    - Required
    - NoEncap
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -Direction Direction:
    values:
    - Inbound
    - Outbound
  -DisplayName String:
    required: true
  -DynamicTarget,-DynamicTransport DynamicTransport:
    values:
    - Any
    - ProximityApps
    - ProximitySharing
    - WifiDirectPrinting
    - WifiDirectDisplay
    - WifiDirectDevices
  -EdgeTraversalPolicy EdgeTraversal:
    values:
    - Block
    - Allow
    - DeferToUser
    - DeferToApp
  -Enabled Enabled:
    values:
    - 'True'
    - 'False'
  -Encryption Encryption:
    values:
    - NotRequired
    - Required
    - Dynamic
  -GPOSession String: ~
  -Group String: ~
  -IcmpType String[]: ~
  -InterfaceAlias WildcardPattern[]: ~
  -InterfaceType InterfaceType:
    values:
    - Any
    - Wired
    - Wireless
    - RemoteAccess
  -LocalAddress String[]: ~
  -LocalOnlyMapping Boolean: ~
  -LocalPort String[]: ~
  -LocalUser String: ~
  -LooseSourceMapping,-LSM Boolean: ~
  -Name,-ID String: ~
  -OverrideBlockRules Boolean: ~
  -Owner String: ~
  -Package String: ~
  -Platform String[]: ~
  -PolicyStore String: ~
  -Profile Profile:
    values:
    - Any
    - Domain
    - Private
    - Public
    - NotApplicable
  -Program String: ~
  -Protocol String: ~
  -RemoteAddress String[]: ~
  -RemoteDynamicKeywordAddresses String[]: ~
  -RemoteMachine String: ~
  -RemotePort String[]: ~
  -RemoteUser String: ~
  -Service String: ~
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
