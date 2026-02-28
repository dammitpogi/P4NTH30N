description: Copies an entire phase 1 authentication set to the same or to a different
  policy store
synopses:
- Copy-NetIPsecPhase1AuthSet [-All] [-PolicyStore <String>] [-GPOSession <String>]
  [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession <String>] [-NewName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecPhase1AuthSet [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession <String>]
  [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecPhase1AuthSet -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession <String>]
  [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecPhase1AuthSet [-Description <String[]>] [-DisplayGroup <String[]>]
  [-Group <String[]>] [-PrimaryStatus <PrimaryStatus[]>] [-Status <String[]>] [-PolicyStoreSource
  <String[]>] [-PolicyStoreSourceType <PolicyStoreType[]>] [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession
  <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecPhase1AuthSet -AssociatedNetIPsecRule <CimInstance> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession
  <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecPhase1AuthSet -AssociatedNetIPsecMainModeRule <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-NewPolicyStore <String>]
  [-NewGPOSession <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecPhase1AuthSet -InputObject <CimInstance[]> [-NewPolicyStore <String>]
  [-NewGPOSession <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -AssociatedNetIPsecMainModeRule CimInstance:
    required: true
  -AssociatedNetIPsecRule CimInstance:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String[]: ~
  -DisplayGroup String[]: ~
  -DisplayName String[]:
    required: true
  -GPOSession String: ~
  -Group String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Name,-ID String[]:
    required: true
  -NewGPOSession String: ~
  -NewName String: ~
  -NewPolicyStore String: ~
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
