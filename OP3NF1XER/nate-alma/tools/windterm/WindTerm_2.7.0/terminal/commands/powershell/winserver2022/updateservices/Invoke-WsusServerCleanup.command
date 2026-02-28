description: Performs the process of cleanup on a WSUS server
synopses:
- powershell Invoke-WsusServerCleanup [-UpdateServer <IUpdateServer>] [-CleanupObsoleteComputers]
  [-CleanupObsoleteUpdates] [-CleanupUnneededContentFiles] [-CompressUpdates] [-DeclineExpiredUpdates]
  [-DeclineSupersededUpdates] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CleanupObsoleteComputers Switch: ~
  -CleanupObsoleteUpdates Switch: ~
  -CleanupUnneededContentFiles Switch: ~
  -CompressUpdates Switch: ~
  -Confirm,-cf Switch: ~
  -DeclineExpiredUpdates Switch: ~
  -DeclineSupersededUpdates Switch: ~
  -UpdateServer IUpdateServer: ~
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
