description: Gets an IPsec rule from the target computer
synopses:
- Get-NetIPsecRule [-All] [-PolicyStore <String>] [-GPOSession <String>] [-TracePolicyStore]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule [-IPsecRuleName] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetIPsecRule [-Description <String[]>] [-DisplayGroup <String[]>] [-Group <String[]>]
  [-Enabled <Enabled[]>] [-Mode <IPsecMode[]>] [-InboundSecurity <SecurityPolicy[]>]
  [-OutboundSecurity <SecurityPolicy[]>] [-QuickModeCryptoSet <String[]>] [-Phase1AuthSet
  <String[]>] [-Phase2AuthSet <String[]>] [-KeyModule <KeyModule[]>] [-AllowWatchKey
  <Boolean[]>] [-AllowSetKey <Boolean[]>] [-RemoteTunnelHostname <String[]>] [-ForwardPathLifetime
  <UInt32[]>] [-EncryptedTunnelBypass <Boolean[]>] [-RequireAuthorization <Boolean[]>]
  [-User <String[]>] [-Machine <String[]>] [-PrimaryStatus <PrimaryStatus[]>] [-Status
  <String[]>] [-PolicyStoreSource <String[]>] [-PolicyStoreSourceType <PolicyStoreType[]>]
  [-PolicyStore <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetFirewallAddressFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetFirewallInterfaceFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetFirewallInterfaceTypeFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetFirewallPortFilter <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetFirewallProfile <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetIPsecPhase2AuthSet <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetIPsecPhase1AuthSet <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPsecRule -AssociatedNetIPsecQuickModeCryptoSet <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
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
  -Description String[]: ~
  -DisplayGroup String[]: ~
  -DisplayName String[]:
    required: true
  -Enabled Enabled[]:
    values:
    - 'True'
    - 'False'
  -EncryptedTunnelBypass Boolean[]: ~
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
  -Status String[]: ~
  -ThrottleLimit Int32: ~
  -TracePolicyStore Switch: ~
  -User String[]: ~
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
