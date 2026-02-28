description: Resets the DNS64 configuration on a computer
synopses:
- Reset-NetDnsTransitionConfiguration [-Adapter <CimInstance>] [-State] [-OnlySendAQuery]
  [-LatencyMilliseconds] [-AlwaysSynthesize] [-AcceptInterface] [-SendInterface] [-ExclusionList]
  [-PrefixMapping] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Reset-NetDnsTransitionConfiguration -InputObject <CimInstance[]> [-State] [-OnlySendAQuery]
  [-LatencyMilliseconds] [-AlwaysSynthesize] [-AcceptInterface] [-SendInterface] [-ExclusionList]
  [-PrefixMapping] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptInterface Switch: ~
  -Adapter CimInstance: ~
  -AlwaysSynthesize Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ExclusionList Switch: ~
  -InputObject CimInstance[]:
    required: true
  -LatencyMilliseconds,-Latency Switch: ~
  -OnlySendAQuery Switch: ~
  -PassThru Switch: ~
  -PrefixMapping Switch: ~
  -SendInterface Switch: ~
  -State Switch: ~
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
