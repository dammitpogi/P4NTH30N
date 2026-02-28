description: Resets the specified DirectAccess entry point configuration to the default
  configuration
synopses:
- Reset-DAEntryPointTableItem [-EntryPointName <String[]>] -PolicyStore <String> [-TeredoServerIP]
  [-IPHttpsProfile] [-GslbIP] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Reset-DAEntryPointTableItem [-EntryPointName <String[]>] -GPOSession <String> [-TeredoServerIP]
  [-IPHttpsProfile] [-GslbIP] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Reset-DAEntryPointTableItem -InputObject <CimInstance[]> [-TeredoServerIP] [-IPHttpsProfile]
  [-GslbIP] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EntryPointName String[]: ~
  -GPOSession String:
    required: true
  -GslbIP Switch: ~
  -IPHttpsProfile Switch: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String:
    required: true
  -TeredoServerIP Switch: ~
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
