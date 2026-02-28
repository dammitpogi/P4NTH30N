description: Modifies properties of a web theme
synopses:
- Set-AdfsWebTheme [-StyleSheet <Hashtable[]>] [-RTLStyleSheetPath <String>] [-OnLoadScriptPath
  <String>] [-Logo <Hashtable[]>] [-Illustration <Hashtable[]>] [-AdditionalFileResource
  <Hashtable[]>] [-PassThru] [-TargetName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsWebTheme [-StyleSheet <Hashtable[]>] [-RTLStyleSheetPath <String>] [-OnLoadScriptPath
  <String>] [-Logo <Hashtable[]>] [-Illustration <Hashtable[]>] [-AdditionalFileResource
  <Hashtable[]>] [-PassThru] [-TargetWebTheme] <AdfsWebTheme> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AdditionalFileResource Hashtable[]: ~
  -Illustration Hashtable[]: ~
  -Logo Hashtable[]: ~
  -OnLoadScriptPath String: ~
  -PassThru Switch: ~
  -RTLStyleSheetPath String: ~
  -StyleSheet Hashtable[]: ~
  -TargetName String:
    required: true
  -TargetWebTheme AdfsWebTheme:
    required: true
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
