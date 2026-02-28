description: Restores files and folders that DFS Replication previously preserved
synopses:
- Restore-DfsrPreservedFiles [-Path] <String> [-RestoreToPath] <String> [-RestoreAllVersions]
  [-CopyFiles] [-AllowClobber] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Restore-DfsrPreservedFiles [-Path] <String> [-RestoreToOrigin] [-RestoreAllVersions]
  [-CopyFiles] [-AllowClobber] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowClobber Switch: ~
  -Confirm,-cf Switch: ~
  -CopyFiles Switch: ~
  -Force Switch: ~
  -Path String:
    required: true
  -RestoreAllVersions Switch: ~
  -RestoreToOrigin Switch:
    required: true
  -RestoreToPath String:
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
