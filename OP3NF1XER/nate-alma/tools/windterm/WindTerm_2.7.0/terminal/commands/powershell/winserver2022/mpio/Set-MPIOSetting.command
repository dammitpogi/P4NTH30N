description: Changes MPIO settings
synopses:
- Set-MPIOSetting [[-NewPathVerificationPeriod] <Int32>] [[-NewPathVerificationState]
  <String>] [[-NewPDORemovePeriod] <Int32>] [[-NewRetryCount] <Int32>] [[-NewRetryInterval]
  <Int32>] [[-NewDiskTimeout] <Int32>] [[-CustomPathRecovery] <String>] [[-NewPathRecoveryInterval]
  <Int32>] [<CommonParameters>]
options:
  -CustomPathRecovery String:
    values:
    - Enabled
    - Disabled
  -NewDiskTimeout Int32: ~
  -NewPDORemovePeriod Int32: ~
  -NewPathRecoveryInterval Int32: ~
  -NewPathVerificationPeriod Int32: ~
  -NewPathVerificationState String:
    values:
    - Enabled
    - Disabled
  -NewRetryCount Int32: ~
  -NewRetryInterval Int32: ~
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
