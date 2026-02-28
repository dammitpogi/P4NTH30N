description: Modifies an existing DoH server configuration
synopses:
- Set-DnsClientDohServerAddress [-ServerAddress] <String[]> [[-DohTemplate] <String>]
  [[-AllowFallbackToUdp] <Boolean>] [[-AutoUpgrade] <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsClientDohServerAddress -InputObject <CimInstance[]> [[-DohTemplate] <String>]
  [[-AllowFallbackToUdp] <Boolean>] [[-AutoUpgrade] <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowFallbackToUdp Boolean: ~
  -AsJob Switch: ~
  -AutoUpgrade Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -DohTemplate String: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -ServerAddress String[]:
    required: true
  -ThrottleLimit Int32: ~
  -Confirm,-cf Switch: ~
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
