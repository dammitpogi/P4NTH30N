description: Sets the DNS64 configuration on a computer
synopses:
- Set-NetDnsTransitionConfiguration [-Adapter <CimInstance>] [-State <State>] [-OnlySendAQuery
  <Boolean>] [-LatencyMilliseconds <UInt32>] [-AlwaysSynthesize <Boolean>] [-AcceptInterface
  <String[]>] [-SendInterface <String[]>] [-ExclusionList <String[]>] [-PrefixMapping
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetDnsTransitionConfiguration -InputObject <CimInstance[]> [-State <State>]
  [-OnlySendAQuery <Boolean>] [-LatencyMilliseconds <UInt32>] [-AlwaysSynthesize <Boolean>]
  [-AcceptInterface <String[]>] [-SendInterface <String[]>] [-ExclusionList <String[]>]
  [-PrefixMapping <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptInterface String[]: ~
  -Adapter CimInstance: ~
  -AlwaysSynthesize Boolean: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ExclusionList String[]: ~
  -InputObject CimInstance[]:
    required: true
  -LatencyMilliseconds,-Latency UInt32: ~
  -OnlySendAQuery Boolean: ~
  -PassThru Switch: ~
  -PrefixMapping String[]: ~
  -SendInterface String[]: ~
  -State State:
    values:
    - Disabled
    - Enabled
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
