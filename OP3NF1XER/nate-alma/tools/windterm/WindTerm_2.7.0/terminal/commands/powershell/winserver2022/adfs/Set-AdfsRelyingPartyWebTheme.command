description: Applies a web theme to a relying party
synopses:
- Set-AdfsRelyingPartyWebTheme [-StyleSheet <Hashtable[]>] [-RTLStyleSheetPath <String>]
  [-OnLoadScriptPath <String>] [-Logo <Hashtable[]>] [-Illustration <Hashtable[]>]
  [-SourceWebThemeName <String>] [-SourceRelyingPartyName <String>] [-TargetRelyingPartyName]
  <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsRelyingPartyWebTheme [-StyleSheet <Hashtable[]>] [-RTLStyleSheetPath <String>]
  [-OnLoadScriptPath <String>] [-Logo <Hashtable[]>] [-Illustration <Hashtable[]>]
  [-SourceWebThemeName <String>] [-SourceRelyingPartyName <String>] [-TargetRelyingPartyWebTheme]
  <AdfsRelyingPartyWebTheme> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Illustration Hashtable[]: ~
  -Logo Hashtable[]: ~
  -OnLoadScriptPath String: ~
  -RTLStyleSheetPath String: ~
  -SourceRelyingPartyName String: ~
  -SourceWebThemeName String: ~
  -StyleSheet Hashtable[]: ~
  -TargetRelyingPartyName,-Name String:
    required: true
  -TargetRelyingPartyWebTheme,-TargetWebTheme AdfsRelyingPartyWebTheme:
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
