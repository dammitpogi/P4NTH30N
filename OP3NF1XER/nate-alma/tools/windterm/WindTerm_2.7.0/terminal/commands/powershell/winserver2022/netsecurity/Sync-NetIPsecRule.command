description: Gets the list of IP addresses to be added and deleted to an IPsec rule
  based on the differences detected between the existing rule IP addresses and the
  specified IP addresses
synopses:
- Sync-NetIPsecRule [-All] [-PolicyStore <String>] [-GPOSession <String>] [-TracePolicyStore]
  [-Servers <String[]>] [-Domains <String[]>] [-EndpointType <EndpointType>] [-AddressType
  <AddressVersion>] [-DnsServers <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule [-IPsecRuleName] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains <String[]>] [-EndpointType
  <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers <String[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-TracePolicyStore] [-Servers <String[]>] [-Domains <String[]>] [-EndpointType <EndpointType>]
  [-AddressType <AddressVersion>] [-DnsServers <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule [-Description <String[]>] [-DisplayGroup <String[]>] [-Group <String[]>]
  [-Enabled <Enabled[]>] [-Mode <IPsecMode[]>] [-InboundSecurity <SecurityPolicy[]>]
  [-OutboundSecurity <SecurityPolicy[]>] [-QuickModeCryptoSet <String[]>] [-Phase1AuthSet
  <String[]>] [-Phase2AuthSet <String[]>] [-KeyModule <KeyModule[]>] [-AllowWatchKey
  <Boolean[]>] [-AllowSetKey <Boolean[]>] [-RemoteTunnelHostname <String[]>] [-ForwardPathLifetime
  <UInt32[]>] [-EncryptedTunnelBypass <Boolean[]>] [-RequireAuthorization <Boolean[]>]
  [-User <String[]>] [-Machine <String[]>] [-PrimaryStatus <PrimaryStatus[]>] [-Status
  <String[]>] [-PolicyStoreSource <String[]>] [-PolicyStoreSourceType <PolicyStoreType[]>]
  [-PolicyStore <String>] [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>]
  [-Domains <String[]>] [-EndpointType <EndpointType>] [-AddressType <AddressVersion>]
  [-DnsServers <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetFirewallAddressFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains
  <String[]>] [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetFirewallInterfaceFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains
  <String[]>] [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetFirewallInterfaceTypeFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains
  <String[]>] [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetFirewallPortFilter <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains <String[]>]
  [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetFirewallProfile <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains <String[]>]
  [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetIPsecPhase2AuthSet <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains <String[]>]
  [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetIPsecPhase1AuthSet <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains <String[]>]
  [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Sync-NetIPsecRule -AssociatedNetIPsecQuickModeCryptoSet <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-Servers <String[]>] [-Domains
  <String[]>] [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Sync-NetIPsecRule -InputObject <CimInstance[]> [-Servers <String[]>] [-Domains <String[]>]
  [-EndpointType <EndpointType>] [-AddressType <AddressVersion>] [-DnsServers <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AddressType AddressVersion:
    values:
    - None
    - IPv4
    - IPv6
  -All Switch: ~
  -AllowSetKey Boolean[]: ~
  -AllowWatchKey Boolean[]: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallAddressFilter CimInstance:
    required: true
  -AssociatedNetFirewallInterfaceFilter CimInstance:
    required: true
  -AssociatedNetFirewallInterfaceTypeFilter CimInstance:
    required: true
  -AssociatedNetFirewallPortFilter CimInstance:
    required: true
  -AssociatedNetFirewallProfile CimInstance:
    required: true
  -AssociatedNetIPsecPhase1AuthSet CimInstance:
    required: true
  -AssociatedNetIPsecPhase2AuthSet CimInstance:
    required: true
  -AssociatedNetIPsecQuickModeCryptoSet CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String[]: ~
  -DisplayGroup String[]: ~
  -DisplayName String[]:
    required: true
  -DnsServers String[]: ~
  -Domains String[]: ~
  -Enabled Enabled[]:
    values:
    - 'True'
    - 'False'
  -EncryptedTunnelBypass Boolean[]: ~
  -EndpointType EndpointType:
    values:
    - Endpoint1
    - Endpoint2
  -ForwardPathLifetime UInt32[]: ~
  -GPOSession String: ~
  -Group String[]: ~
  -IPsecRuleName,-ID,-Name String[]:
    required: true
  -InboundSecurity,-SecIn SecurityPolicy[]:
    values:
    - None
    - Request
    - Require
  -InputObject CimInstance[]:
    required: true
  -KeyModule KeyModule[]:
    values:
    - Default
    - IKEv1
    - AuthIP
    - IKEv2
  -Machine String[]: ~
  -Mode IPsecMode[]:
    values:
    - None
    - Tunnel
    - Transport
  -OutboundSecurity,-SecOut SecurityPolicy[]:
    values:
    - None
    - Request
    - Require
  -Phase1AuthSet String[]: ~
  -Phase2AuthSet String[]: ~
  -PolicyStore String: ~
  -PolicyStoreSource String[]: ~
  -PolicyStoreSourceType PolicyStoreType[]:
    values:
    - None
    - Local
    - GroupPolicy
    - Dynamic
    - Generated
    - Hardcoded
  -PrimaryStatus PrimaryStatus[]:
    values:
    - Unknown
    - OK
    - Inactive
    - Error
  -QuickModeCryptoSet String[]: ~
  -RemoteTunnelHostname String[]: ~
  -RequireAuthorization Boolean[]: ~
  -Servers String[]: ~
  -Status String[]: ~
  -ThrottleLimit Int32: ~
  -TracePolicyStore Switch: ~
  -User String[]: ~
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
