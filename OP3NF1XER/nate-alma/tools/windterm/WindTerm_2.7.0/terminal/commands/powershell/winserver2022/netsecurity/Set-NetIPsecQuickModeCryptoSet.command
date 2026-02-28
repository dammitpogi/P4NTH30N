description: Modifies existing quick mode cryptographic sets
synopses:
- Set-NetIPsecQuickModeCryptoSet [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-PerfectForwardSecrecyGroup <DiffieHellmanGroup>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecQuickModeCryptoSet -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-PerfectForwardSecrecyGroup <DiffieHellmanGroup>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecQuickModeCryptoSet -DisplayGroup <String[]> [-PolicyStore <String>]
  [-GPOSession <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal
  <CimInstance[]>] [-PerfectForwardSecrecyGroup <DiffieHellmanGroup>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-NetIPsecQuickModeCryptoSet -Group <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-PerfectForwardSecrecyGroup <DiffieHellmanGroup>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecQuickModeCryptoSet -InputObject <CimInstance[]> [-NewDisplayName <String>]
  [-Description <String>] [-Proposal <CimInstance[]>] [-PerfectForwardSecrecyGroup
  <DiffieHellmanGroup>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayGroup String[]:
    required: true
  -DisplayName String[]:
    required: true
  -GPOSession String: ~
  -Group String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Name,-ID String[]:
    required: true
  -NewDisplayName String: ~
  -PassThru Switch: ~
  -PerfectForwardSecrecyGroup,-PfsGroup DiffieHellmanGroup:
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
  -Proposal CimInstance[]: ~
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
