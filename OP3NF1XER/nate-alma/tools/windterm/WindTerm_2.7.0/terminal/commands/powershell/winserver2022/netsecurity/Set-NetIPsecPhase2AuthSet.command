description: Modifies existing phase 2 authentication sets
synopses:
- Set-NetIPsecPhase2AuthSet [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetIPsecPhase2AuthSet -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetIPsecPhase2AuthSet -DisplayGroup <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetIPsecPhase2AuthSet -Group <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetIPsecPhase2AuthSet -InputObject <CimInstance[]> [-NewDisplayName <String>]
  [-Description <String>] [-Proposal <CimInstance[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
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
