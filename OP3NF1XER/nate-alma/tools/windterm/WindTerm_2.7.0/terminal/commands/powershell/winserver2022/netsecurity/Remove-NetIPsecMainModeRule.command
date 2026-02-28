description: Deletes any main mode rules that match the specified criteria
synopses:
- Remove-NetIPsecMainModeRule [-All] [-PolicyStore <String>] [-GPOSession <String>]
  [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule [-Description <String[]>] [-DisplayGroup <String[]>]
  [-Group <String[]>] [-Enabled <Enabled[]>] [-MainModeCryptoSet <String[]>] [-Phase1AuthSet
  <String[]>] [-PrimaryStatus <PrimaryStatus[]>] [-Status <String[]>] [-PolicyStoreSource
  <String[]>] [-PolicyStoreSourceType <PolicyStoreType[]>] [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule -AssociatedNetFirewallAddressFilter <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule -AssociatedNetFirewallProfile <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule -AssociatedNetIPsecPhase1AuthSet <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule -AssociatedNetIPsecMainModeCryptoSet <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-NetIPsecMainModeRule -InputObject <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetFirewallAddressFilter CimInstance:
    required: true
  -AssociatedNetFirewallProfile CimInstance:
    required: true
  -AssociatedNetIPsecMainModeCryptoSet CimInstance:
    required: true
  -AssociatedNetIPsecPhase1AuthSet CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String[]: ~
  -DisplayGroup String[]: ~
  -DisplayName String[]:
    required: true
  -Enabled Enabled[]:
    values:
    - 'True'
    - 'False'
  -GPOSession String: ~
  -Group String[]: ~
  -InputObject CimInstance[]:
    required: true
  -MainModeCryptoSet String[]: ~
  -Name,-ID String[]:
    required: true
  -PassThru Switch: ~
  -Phase1AuthSet String[]: ~
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
