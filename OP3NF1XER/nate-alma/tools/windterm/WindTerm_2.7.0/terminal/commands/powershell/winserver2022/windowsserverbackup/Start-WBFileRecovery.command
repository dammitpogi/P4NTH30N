description: Starts a file recovery operation
synopses:
- Start-WBFileRecovery [-BackupSet] <WBBackupSet> [-SourcePath] <String> [[-TargetPath]
  <String>] [[-Option] <WBFileRecoveryOptions>] [-Recursive] [-NoRestoreAcl] [-Async]
  [-Force] [<CommonParameters>]
options:
  -Async Switch: ~
  -BackupSet WBBackupSet:
    required: true
  -Force Switch: ~
  -NoRestoreAcl Switch: ~
  -Option WBFileRecoveryOptions:
    values:
    - Default
    - SkipIfExists
    - CreateCopyIfExists
    - OverwriteIfExists
  -Recursive Switch: ~
  -SourcePath String:
    required: true
  -TargetPath String: ~
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
