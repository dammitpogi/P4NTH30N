description: Tests whether you can restore an AD FS farm to a previous behavior level
synopses:
- Test-AdfsFarmBehaviorLevelRestore [-Member <String[]>] [-Credential <PSCredential>]
  -FarmBehavior <Int32> [-Force] [<CommonParameters>]
options:
  -Credential PSCredential: ~
  -FarmBehavior Int32:
    required: true
  -Force Switch: ~
  -Member String[]: ~
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
