description: Repairs one or more virtual machines
synopses:
- Repair-VM [-CompatibilityReport] <VMCompatibilityReport> [-SnapshotFilePath <String>]
  [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CompatibilityReport VMCompatibilityReport:
    required: true
  -Confirm,-cf Switch: ~
  -Passthru Switch: ~
  -Path String: ~
  -SnapshotFilePath,-CheckpointFileLocation,-SnapshotFileLocation String: ~
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
