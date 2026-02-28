description: Retrieves firewall rules from the target computer
synopses:
- Get-NetFirewallRule [-All] [-PolicyStore <String>] [-TracePolicyStore] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule [-Name] <String[]> [-PolicyStore <String>] [-TracePolicyStore]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -DisplayName <String[]> [-PolicyStore <String>] [-TracePolicyStore]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule [-Description <String[]>] [-DisplayGroup <String[]>] [-Group
  <String[]>] [-Enabled <Enabled[]>] [-Direction <Direction[]>] [-Action <Action[]>]
  [-EdgeTraversalPolicy <EdgeTraversal[]>] [-LooseSourceMapping <Boolean[]>] [-LocalOnlyMapping
  <Boolean[]>] [-Owner <String[]>] [-PrimaryStatus <PrimaryStatus[]>] [-Status <String[]>]
  [-PolicyStoreSource <String[]>] [-PolicyStoreSourceType <PolicyStoreType[]>] [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallAddressFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallApplicationFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallInterfaceFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallInterfaceTypeFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallPortFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallSecurityFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallServiceFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetFirewallRule -AssociatedNetFirewallProfile <CimInstance> [-PolicyStore <String>]
  [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -Action Action[]:
    values:
    - NotConfigured
    - Allow
    - Block
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallAddressFilter CimInstance:
    required: true
  -AssociatedNetFirewallApplicationFilter CimInstance:
    required: true
  -AssociatedNetFirewallInterfaceFilter CimInstance:
    required: true
  -AssociatedNetFirewallInterfaceTypeFilter CimInstance:
    required: true
  -AssociatedNetFirewallPortFilter CimInstance:
    required: true
  -AssociatedNetFirewallProfile CimInstance:
    required: true
  -AssociatedNetFirewallSecurityFilter CimInstance:
    required: true
  -AssociatedNetFirewallServiceFilter CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Description String[]: ~
  -Direction Direction[]:
    values:
    - Inbound
    - Outbound
  -DisplayGroup String[]: ~
  -DisplayName String[]:
    required: true
  -EdgeTraversalPolicy EdgeTraversal[]:
    values:
    - Block
    - Allow
    - DeferToUser
    - DeferToApp
  -Enabled Enabled[]:
    values:
    - 'True'
    - 'False'
  -Group String[]: ~
  -LocalOnlyMapping Boolean[]: ~
  -LooseSourceMapping,-LSM Boolean[]: ~
  -Name,-ID String[]:
    required: true
  -Owner String[]: ~
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
  -Status String[]: ~
  -ThrottleLimit Int32: ~
  -TracePolicyStore Switch: ~
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
