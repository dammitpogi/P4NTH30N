description: Imports selected Windows features, and operating system settings from
  a migration store, and applies them to the local computer
synopses:
- Import-SmigServerSetting [-Feature <Feature[]>] [-FeatureId <String[]>] [-Group]
  [-SourcePhysicalAddress <String[]>] [-TargetPhysicalAddress <String[]>] [-Force]
  -Path <String> [-User <String>] [-IPConfig <String>] -Password <SecureString> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Feature,-F Feature[]: ~
  -FeatureId,-ID String[]: ~
  -Force Switch: ~
  -Group Switch: ~
  -IPConfig String: ~
  -Password SecureString:
    required: true
  -Path String:
    required: true
  -SourcePhysicalAddress String[]: ~
  -TargetPhysicalAddress String[]: ~
  -User String: ~
  -WhatIf,-wi Switch: ~
  -Confirm,-cf Switch: ~
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
