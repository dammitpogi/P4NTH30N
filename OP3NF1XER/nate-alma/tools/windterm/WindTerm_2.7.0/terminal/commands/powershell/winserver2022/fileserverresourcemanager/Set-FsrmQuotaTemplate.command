description: Changes configuration settings for FSRM quota templates
synopses:
- Set-FsrmQuotaTemplate [-Name] <String[]> [-Description <String>] [-Size <UInt64>]
  [-SoftLimit] [-UpdateDerived] [-UpdateDerivedMatching] [-Threshold <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-FsrmQuotaTemplate -InputObject <CimInstance[]> [-Description <String>] [-Size
  <UInt64>] [-SoftLimit] [-UpdateDerived] [-UpdateDerivedMatching] [-Threshold <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -Size UInt64: ~
  -SoftLimit Switch: ~
  -Threshold CimInstance[]: ~
  -ThrottleLimit Int32: ~
  -UpdateDerived Switch: ~
  -UpdateDerivedMatching Switch: ~
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
