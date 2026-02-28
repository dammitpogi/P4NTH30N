description: Modifies existing IPsec rules
synopses:
- Set-NetIPsecRule [-IPsecRuleName] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-Mode <IPsecMode>] [-InboundSecurity
  <SecurityPolicy>] [-OutboundSecurity <SecurityPolicy>] [-QuickModeCryptoSet <String>]
  [-Phase1AuthSet <String>] [-Phase2AuthSet <String>] [-KeyModule <KeyModule>] [-AllowWatchKey
  <Boolean>] [-AllowSetKey <Boolean>] [-LocalTunnelEndpoint <String[]>] [-RemoteTunnelEndpoint
  <String[]>] [-RemoteTunnelHostname <String>] [-ForwardPathLifetime <UInt32>] [-EncryptedTunnelBypass
  <Boolean>] [-RequireAuthorization <Boolean>] [-User <String>] [-Machine <String>]
  [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-Protocol <String>] [-LocalPort
  <String[]>] [-RemotePort <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType
  <InterfaceType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecRule -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>] [-Profile
  <Profile>] [-Platform <String[]>] [-Mode <IPsecMode>] [-InboundSecurity <SecurityPolicy>]
  [-OutboundSecurity <SecurityPolicy>] [-QuickModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-Phase2AuthSet <String>] [-KeyModule <KeyModule>] [-AllowWatchKey <Boolean>]
  [-AllowSetKey <Boolean>] [-LocalTunnelEndpoint <String[]>] [-RemoteTunnelEndpoint
  <String[]>] [-RemoteTunnelHostname <String>] [-ForwardPathLifetime <UInt32>] [-EncryptedTunnelBypass
  <Boolean>] [-RequireAuthorization <Boolean>] [-User <String>] [-Machine <String>]
  [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-Protocol <String>] [-LocalPort
  <String[]>] [-RemotePort <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType
  <InterfaceType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecRule -DisplayGroup <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>] [-Profile
  <Profile>] [-Platform <String[]>] [-Mode <IPsecMode>] [-InboundSecurity <SecurityPolicy>]
  [-OutboundSecurity <SecurityPolicy>] [-QuickModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-Phase2AuthSet <String>] [-KeyModule <KeyModule>] [-AllowWatchKey <Boolean>]
  [-AllowSetKey <Boolean>] [-LocalTunnelEndpoint <String[]>] [-RemoteTunnelEndpoint
  <String[]>] [-RemoteTunnelHostname <String>] [-ForwardPathLifetime <UInt32>] [-EncryptedTunnelBypass
  <Boolean>] [-RequireAuthorization <Boolean>] [-User <String>] [-Machine <String>]
  [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-Protocol <String>] [-LocalPort
  <String[]>] [-RemotePort <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType
  <InterfaceType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecRule -Group <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>] [-Profile
  <Profile>] [-Platform <String[]>] [-Mode <IPsecMode>] [-InboundSecurity <SecurityPolicy>]
  [-OutboundSecurity <SecurityPolicy>] [-QuickModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-Phase2AuthSet <String>] [-KeyModule <KeyModule>] [-AllowWatchKey <Boolean>]
  [-AllowSetKey <Boolean>] [-LocalTunnelEndpoint <String[]>] [-RemoteTunnelEndpoint
  <String[]>] [-RemoteTunnelHostname <String>] [-ForwardPathLifetime <UInt32>] [-EncryptedTunnelBypass
  <Boolean>] [-RequireAuthorization <Boolean>] [-User <String>] [-Machine <String>]
  [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-Protocol <String>] [-LocalPort
  <String[]>] [-RemotePort <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType
  <InterfaceType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecRule -InputObject <CimInstance[]> [-NewDisplayName <String>] [-Description
  <String>] [-Enabled <Enabled>] [-Profile <Profile>] [-Platform <String[]>] [-Mode
  <IPsecMode>] [-InboundSecurity <SecurityPolicy>] [-OutboundSecurity <SecurityPolicy>]
  [-QuickModeCryptoSet <String>] [-Phase1AuthSet <String>] [-Phase2AuthSet <String>]
  [-KeyModule <KeyModule>] [-AllowWatchKey <Boolean>] [-AllowSetKey <Boolean>] [-LocalTunnelEndpoint
  <String[]>] [-RemoteTunnelEndpoint <String[]>] [-RemoteTunnelHostname <String>]
  [-ForwardPathLifetime <UInt32>] [-EncryptedTunnelBypass <Boolean>] [-RequireAuthorization
  <Boolean>] [-User <String>] [-Machine <String>] [-LocalAddress <String[]>] [-RemoteAddress
  <String[]>] [-Protocol <String>] [-LocalPort <String[]>] [-RemotePort <String[]>]
  [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AllowSetKey Boolean: ~
  -AllowWatchKey Boolean: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayGroup String[]:
    required: true
  -DisplayName String[]:
    required: true
  -Enabled Enabled:
    values:
    - 'True'
    - 'False'
  -EncryptedTunnelBypass Boolean: ~
  -ForwardPathLifetime UInt32: ~
  -GPOSession String: ~
  -Group String[]:
    required: true
  -IPsecRuleName,-ID,-Name String[]:
    required: true
  -InboundSecurity,-SecIn SecurityPolicy:
    values:
    - None
    - Request
    - Require
  -InputObject CimInstance[]:
    required: true
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
  -NewDisplayName String: ~
  -OutboundSecurity,-SecOut SecurityPolicy:
    values:
    - None
    - Request
    - Require
  -PassThru Switch: ~
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
