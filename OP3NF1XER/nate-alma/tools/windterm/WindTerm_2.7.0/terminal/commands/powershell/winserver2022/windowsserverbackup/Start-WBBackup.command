description: Starts a one-time backup operation
synopses:
- Start-WBBackup [-Policy] <WBPolicy> [-Async] [-Force] [-AllowDeleteOldBackups] [-DoNotVerifyMedia]
  [<CommonParameters>]
options:
  -AllowDeleteOldBackups Switch: ~
  -Async Switch: ~
  -DoNotVerifyMedia Switch: ~
  -Force Switch: ~
  -Policy WBPolicy:
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
