description: Sets an ISATAP configuration on a computer or on a Group Policy Object
  (GPO)
synopses:
- Set-NetIsatapConfiguration [-IPInterface <CimInstance>] [-PolicyStore <String>]
  [-GPOSession <String>] [[-State] <State>] [[-Router] <String>] [[-ResolutionState]
  <State>] [[-ResolutionIntervalSeconds] <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIsatapConfiguration -InputObject <CimInstance[]> [[-State] <State>] [[-Router]
  <String>] [[-ResolutionState] <State>] [[-ResolutionIntervalSeconds] <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -GPOSession String: ~
  -IPInterface CimInstance: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -ResolutionIntervalSeconds,-ResolutionInterval UInt32: ~
  -ResolutionState State:
    values:
    - Default
    - Automatic
    - Enabled
    - Disabled
  -Router String: ~
  -State State:
    values:
    - Default
    - Automatic
    - Enabled
    - Disabled
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
