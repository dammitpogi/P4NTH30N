description: Creates an IPsec rule that defines security requirements for network
  connections that match the specified criteria
synopses:
- New-NetIPsecRule [-PolicyStore <String>] [-GPOSession <String>] [-IPsecRuleName
  <String>] -DisplayName <String> [-Description <String>] [-Group <String>] [-Enabled
  <Enabled>] [-Profile <Profile>] [-Platform <String[]>] [-Mode <IPsecMode>] [-InboundSecurity
  <SecurityPolicy>] [-OutboundSecurity <SecurityPolicy>] [-QuickModeCryptoSet <String>]
  [-Phase1AuthSet <String>] [-Phase2AuthSet <String>] [-KeyModule <KeyModule>] [-AllowWatchKey
  <Boolean>] [-AllowSetKey <Boolean>] [-LocalTunnelEndpoint <String[]>] [-RemoteTunnelEndpoint
  <String[]>] [-RemoteTunnelHostname <String>] [-ForwardPathLifetime <UInt32>] [-EncryptedTunnelBypass
  <Boolean>] [-RequireAuthorization <Boolean>] [-User <String>] [-Machine <String>]
  [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-Protocol <String>] [-LocalPort
  <String[]>] [-RemotePort <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType
  <InterfaceType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowSetKey Boolean: ~
  -AllowWatchKey Boolean: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayName String:
    required: true
  -Enabled Enabled:
    values:
    - 'True'
    - 'False'
  -EncryptedTunnelBypass Boolean: ~
  -ForwardPathLifetime UInt32: ~
  -GPOSession String: ~
  -Group String: ~
  -IPsecRuleName,-ID,-Name String: ~
  -InboundSecurity,-SecIn SecurityPolicy:
    values:
    - None
    - Request
    - Require
  -InterfaceAlias WildcardPattern[]: ~
  -InterfaceType InterfaceType:
    values:
    - Any
    - Wired
    - Wireless
    - RemoteAccess
  -KeyModule KeyModule:
    values:
    - Default
    - IKEv1
    - AuthIP
    - IKEv2
  -LocalAddress String[]: ~
  -LocalPort String[]: ~
  -LocalTunnelEndpoint String[]: ~
  -Machine String: ~
  -Mode IPsecMode:
    values:
    - None
    - Tunnel
    - Transport
  -OutboundSecurity,-SecOut SecurityPolicy:
    values:
    - None
    - Request
    - Require
  -Phase1AuthSet String: ~
  -Phase2AuthSet String: ~
  -Platform String[]: ~
  -PolicyStore String: ~
  -Profile Profile:
    values:
    - Any
    - Domain
    - Private
    - Public
    - NotApplicable
  -Protocol String: ~
  -QuickModeCryptoSet String: ~
  -RemoteAddress String[]: ~
  -RemotePort String[]: ~
  -RemoteTunnelEndpoint String[]: ~
  -RemoteTunnelHostname String: ~
  -RequireAuthorization Boolean: ~
  -ThrottleLimit Int32: ~
  -User String: ~
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
