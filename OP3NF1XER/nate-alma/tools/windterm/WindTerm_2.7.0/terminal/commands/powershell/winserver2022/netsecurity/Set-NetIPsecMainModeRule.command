description: Modifies existing main mode rules
synopses:
- Set-NetIPsecMainModeRule [-Name] <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-MainModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecMainModeRule -DisplayName <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-MainModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecMainModeRule -DisplayGroup <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-MainModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecMainModeRule -Group <String[]> [-PolicyStore <String>] [-GPOSession
  <String>] [-NewDisplayName <String>] [-Description <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-MainModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPsecMainModeRule -InputObject <CimInstance[]> [-NewDisplayName <String>]
  [-Description <String>] [-Enabled <Enabled>] [-Profile <Profile>] [-Platform <String[]>]
  [-MainModeCryptoSet <String>] [-Phase1AuthSet <String>] [-LocalAddress <String[]>]
  [-RemoteAddress <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayGroup String[]:
    required: true
  -DisplayName String[]:
    required: true
  -Enabled Enabled:
    values:
    - 'True'
    - 'False'
  -GPOSession String: ~
  -Group String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -LocalAddress String[]: ~
  -MainModeCryptoSet String: ~
  -Name,-ID String[]:
    required: true
  -NewDisplayName String: ~
  -PassThru Switch: ~
  -Phase1AuthSet String: ~
  -Platform String[]: ~
  -PolicyStore String: ~
  -Profile Profile:
    values:
    - Any
    - Domain
    - Private
    - Public
    - NotApplicable
  -RemoteAddress String[]: ~
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
