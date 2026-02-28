description: Exports selected Windows features and operating system settings from
  the local computer, and stores them in a migration store
synopses:
- Export-SmigServerSetting [-FeatureId <String[]>] [-Feature <Feature[]>] [-User <String>]
  [-Group] [-IPConfig] -Path <String> -Password <SecureString> [<CommonParameters>]
options:
  -Feature,-F Feature[]: ~
  -FeatureId,-ID String[]: ~
  -Group Switch: ~
  -IPConfig Switch: ~
  -Password SecureString:
    required: true
  -Path String:
    required: true
  -User String: ~
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
