description: Starts a volume recovery operation
synopses:
- Start-WBVolumeRecovery [-BackupSet] <WBBackupSet> [-VolumeInBackup] <WBVolume> [[-RecoveryTargetVolume]
  <WBVolume>] [-SkipBadClusterCheck] [-Async] [-Force] [<CommonParameters>]
options:
  -Async Switch: ~
  -BackupSet WBBackupSet:
    required: true
  -Force Switch: ~
  -RecoveryTargetVolume WBVolume: ~
  -SkipBadClusterCheck Switch: ~
  -VolumeInBackup WBVolume:
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
