description: Disables a firewall rule
synopses:
- Disable-NetFirewallRule [-All] [-PolicyStore <String>] [-TracePolicyStore] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-NetFirewallRule [-Name] <String[]> [-PolicyStore <String>] [-TracePolicyStore]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -DisplayName <String[]> [-PolicyStore <String>] [-TracePolicyStore]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule [-Description <String[]>] [-DisplayGroup <String[]>] [-Group
  <String[]>] [-Enabled <Enabled[]>] [-Direction <Direction[]>] [-Action <Action[]>]
  [-EdgeTraversalPolicy <EdgeTraversal[]>] [-LooseSourceMapping <Boolean[]>] [-LocalOnlyMapping
  <Boolean[]>] [-Owner <String[]>] [-PrimaryStatus <PrimaryStatus[]>] [-Status <String[]>]
  [-PolicyStoreSource <String[]>] [-PolicyStoreSourceType <PolicyStoreType[]>] [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallAddressFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallApplicationFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallInterfaceFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallInterfaceTypeFilter <CimInstance>
  [-PolicyStore <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallPortFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallSecurityFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallServiceFilter <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -AssociatedNetFirewallProfile <CimInstance> [-PolicyStore
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-NetFirewallRule -InputObject <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -Confirm,-cf Switch: ~
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
  -InputObject CimInstance[]:
    required: true
  -LocalOnlyMapping Boolean[]: ~
  -LooseSourceMapping,-LSM Boolean[]: ~
  -Name,-ID String[]:
    required: true
  -Owner String[]: ~
  -PassThru Switch: ~
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
