description: Configures a new entry point for multisite DirectAccess
synopses:
- New-DAEntryPointTableItem [-PolicyStore] <String> -EntryPointName <String> -ADSite
  <String> -EntryPointRange <String[]> [-TeredoServerIP <String>] -EntryPointIPAddress
  <String> [-GslbIP <String>] [-IPHttpsProfile <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-DAEntryPointTableItem -EntryPointName <String> -ADSite <String> -EntryPointRange
  <String[]> [-TeredoServerIP <String>] -EntryPointIPAddress <String> [-GslbIP <String>]
  [-IPHttpsProfile <String>] [-GPOSession] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADSite String:
    required: true
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EntryPointIPAddress String:
    required: true
  -EntryPointName String:
    required: true
  -EntryPointRange String[]:
    required: true
  -GPOSession String:
    required: true
  -GslbIP String: ~
  -IPHttpsProfile String: ~
  -PolicyStore String:
    required: true
  -TeredoServerIP String: ~
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
