description: Copies an entire quick mode cryptographic set to the same or to a different
  policy store
synopses:
- Copy-NetIPsecQuickModeCryptoSet [-All] [-PolicyStore <String>] [-GPOSession <String>]
  [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession <String>] [-NewName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecQuickModeCryptoSet [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession <String>]
  [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecQuickModeCryptoSet -DisplayName <String[]> [-PolicyStore <String>]
  [-GPOSession <String>] [-TracePolicyStore] [-NewPolicyStore <String>] [-NewGPOSession
  <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecQuickModeCryptoSet [-Description <String[]>] [-DisplayGroup <String[]>]
  [-Group <String[]>] [-PerfectForwardSecrecyGroup <DiffieHellmanGroup[]>] [-PrimaryStatus
  <PrimaryStatus[]>] [-Status <String[]>] [-PolicyStoreSource <String[]>] [-PolicyStoreSourceType
  <PolicyStoreType[]>] [-PolicyStore <String>] [-GPOSession <String>] [-TracePolicyStore]
  [-NewPolicyStore <String>] [-NewGPOSession <String>] [-NewName <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Copy-NetIPsecQuickModeCryptoSet -AssociatedNetIPsecRule <CimInstance> [-PolicyStore
  <String>] [-GPOSession <String>] [-TracePolicyStore] [-NewPolicyStore <String>]
  [-NewGPOSession <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Copy-NetIPsecQuickModeCryptoSet -InputObject <CimInstance[]> [-NewPolicyStore <String>]
  [-NewGPOSession <String>] [-NewName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
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
  -PerfectForwardSecrecyGroup,-PfsGroup DiffieHellmanGroup[]:
    values:
    - None
    - DH1
    - DH2
    - DH14
    - DH19
    - DH20
    - DH24
    - SameAsMainMode
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
