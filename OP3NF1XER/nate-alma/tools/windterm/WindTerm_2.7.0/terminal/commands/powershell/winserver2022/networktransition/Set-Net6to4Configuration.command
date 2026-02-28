description: Sets the 6to4 configuration for both client computers and servers
synopses:
- Set-Net6to4Configuration [-IPInterface <CimInstance>] [-PolicyStore <String>] [-GPOSession
  <String>] [[-State] <State>] [[-AutoSharing] <State>] [[-RelayName] <String>] [[-RelayState]
  <State>] [[-ResolutionIntervalSeconds] <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Net6to4Configuration -InputObject <CimInstance[]> [[-State] <State>] [[-AutoSharing]
  <State>] [[-RelayName] <String>] [[-RelayState] <State>] [[-ResolutionIntervalSeconds]
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutoSharing State:
    values:
    - Default
    - Automatic
    - Enabled
    - Disabled
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -GPOSession String: ~
  -IPInterface CimInstance: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -RelayName String: ~
  -RelayState State:
    values:
    - Default
    - Automatic
    - Enabled
    - Disabled
  -ResolutionIntervalSeconds,-ResolutionInterval UInt32: ~
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
