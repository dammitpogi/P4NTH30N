description: Runs a command in the context of a specified app package
synopses:
- Invoke-CommandInDesktopPackage [-PackageFamilyName] <String> [[-AppId] <String>]
  [-Command] <String> [[-Args] <String>] [-PreventBreakaway] [<CommonParameters>]
options:
  -AppId String: ~
  -Args String: ~
  -Command String:
    required: true
  -PackageFamilyName String:
    required: true
  -PreventBreakaway Switch: ~
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
