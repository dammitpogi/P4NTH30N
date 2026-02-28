description: Exports the cloned DFS Replication database and volume configuration
  settings
synopses:
- Export-DfsrClone [-Volume] <String> [[-Path] <String>] [[-Validation] <ValidationLevel>]
  [-AllowClobber] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowClobber,-Overwrite Switch: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -Path,-DestinationFolderPath String: ~
  -Validation ValidationLevel:
    values:
    - None
    - Basic
    - Full
  -Volume String:
    required: true
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
