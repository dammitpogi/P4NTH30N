description: Modifies existing main mode cryptographic sets
synopses:
- Set-NetIPsecMainModeCryptoSet [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-MaxMinutes <UInt32>] [-MaxSessions <UInt32>] [-ForceDiffieHellman <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-NetIPsecMainModeCryptoSet -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-MaxMinutes <UInt32>] [-MaxSessions <UInt32>] [-ForceDiffieHellman <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-NetIPsecMainModeCryptoSet -DisplayGroup <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-MaxMinutes <UInt32>] [-MaxSessions <UInt32>] [-ForceDiffieHellman <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-NetIPsecMainModeCryptoSet -Group <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Proposal <CimInstance[]>]
  [-MaxMinutes <UInt32>] [-MaxSessions <UInt32>] [-ForceDiffieHellman <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-NetIPsecMainModeCryptoSet -InputObject <CimInstance[]> [-NewDisplayName <String>]
  [-Description <String>] [-Proposal <CimInstance[]>] [-MaxMinutes <UInt32>] [-MaxSessions
  <UInt32>] [-ForceDiffieHellman <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayGroup String[]:
    required: true
  -DisplayName String[]:
    required: true
  -ForceDiffieHellman Boolean: ~
  -GPOSession String: ~
  -Group String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -MaxMinutes UInt32: ~
  -MaxSessions UInt32: ~
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
