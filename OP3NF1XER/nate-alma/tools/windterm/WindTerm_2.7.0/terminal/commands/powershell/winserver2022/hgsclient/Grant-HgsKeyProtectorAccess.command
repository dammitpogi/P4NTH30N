description: Grants access to a guardian for a key protector
synopses:
- Grant-HgsKeyProtectorAccess -KeyProtector <CimInstance> -Guardian <CimInstance>
  [-AllowUntrustedRoot] [-AllowExpired] [<CommonParameters>]
- Grant-HgsKeyProtectorAccess -KeyProtector <CimInstance> -GuardianFriendlyName <String>
  [-AllowUntrustedRoot] [-AllowExpired] [<CommonParameters>]
options:
  -AllowExpired Switch: ~
  -AllowUntrustedRoot Switch: ~
  -Guardian CimInstance:
    required: true
  -GuardianFriendlyName String:
    required: true
  -KeyProtector CimInstance:
    required: true
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
