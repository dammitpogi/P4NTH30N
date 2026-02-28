description: Resets the GPO settings for a 6to4 configuration
synopses:
- Reset-Net6to4Configuration [-IPInterface <CimInstance>] [-PolicyStore <String>]
  [-GPOSession <String>] [-State] [-AutoSharing] [-RelayName] [-RelayState] [-ResolutionIntervalSeconds]
  [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Reset-Net6to4Configuration -InputObject <CimInstance[]> [-State] [-AutoSharing]
  [-RelayName] [-RelayState] [-ResolutionIntervalSeconds] [-PassThru] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutoSharing Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -GPOSession String: ~
  -IPInterface CimInstance: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -RelayName Switch: ~
  -RelayState Switch: ~
  -ResolutionIntervalSeconds,-ResolutionInterval Switch: ~
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
