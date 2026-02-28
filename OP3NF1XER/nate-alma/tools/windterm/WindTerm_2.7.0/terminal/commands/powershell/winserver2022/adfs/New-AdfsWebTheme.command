description: Creates an AD FS web theme
synopses:
- New-AdfsWebTheme -Name <String> [-SourceName <String>] [-StyleSheet <Hashtable[]>]
  [-RTLStyleSheetPath <String>] [-OnLoadScriptPath <String>] [-Logo <Hashtable[]>]
  [-Illustration <Hashtable[]>] [-AdditionalFileResource <Hashtable[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AdditionalFileResource Hashtable[]: ~
  -Illustration Hashtable[]: ~
  -Logo Hashtable[]: ~
  -Name String:
    required: true
  -OnLoadScriptPath String: ~
  -RTLStyleSheetPath String: ~
  -SourceName String: ~
  -StyleSheet Hashtable[]: ~
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
