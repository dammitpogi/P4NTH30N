description: Modifies the configuration of a DirectAccess entry point stored in a
  Group Policy object
synopses:
- Set-DAEntryPointTableItem [-EntryPointName <String[]>] -PolicyStore <String> [-ADSite
  <String>] [-EntryPointRange <String[]>] [-TeredoServerIP <String>] [-EntryPointIPAddress
  <String>] [-GslbIP <String>] [-IPHttpsProfile <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DAEntryPointTableItem [-EntryPointName <String[]>] -GPOSession <String> [-ADSite
  <String>] [-EntryPointRange <String[]>] [-TeredoServerIP <String>] [-EntryPointIPAddress
  <String>] [-GslbIP <String>] [-IPHttpsProfile <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DAEntryPointTableItem -InputObject <CimInstance[]> [-ADSite <String>] [-EntryPointRange
  <String[]>] [-TeredoServerIP <String>] [-EntryPointIPAddress <String>] [-GslbIP
  <String>] [-IPHttpsProfile <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADSite String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EntryPointIPAddress String: ~
  -EntryPointName String[]: ~
  -EntryPointRange String[]: ~
  -GPOSession String:
    required: true
  -GslbIP String: ~
  -IPHttpsProfile String: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
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
