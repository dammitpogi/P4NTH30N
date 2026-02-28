description: Creates an IPsec main mode rule that tells the computer which peers require
  IPsec security associations (SAs) for securing network traffic, and how to negotiate
  those SAs
synopses:
- New-NetIPsecMainModeRule [-PolicyStore <String>] [-GPOSession <String>] [-Name <String>]
  -DisplayName <String> [-Description <String>] [-Group <String>] [-Enabled <Enabled>]
  [-Profile <Profile>] [-Platform <String[]>] [-MainModeCryptoSet <String>] [-Phase1AuthSet
  <String>] [-LocalAddress <String[]>] [-RemoteAddress <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayName String:
    required: true
  -Enabled Enabled:
    values:
    - 'True'
    - 'False'
  -GPOSession String: ~
  -Group String: ~
  -LocalAddress String[]: ~
  -MainModeCryptoSet String: ~
  -Name,-ID String: ~
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
