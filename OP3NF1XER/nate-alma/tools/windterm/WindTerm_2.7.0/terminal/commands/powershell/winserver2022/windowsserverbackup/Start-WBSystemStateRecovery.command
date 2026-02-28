description: Starts a system state recovery operation
synopses:
- Start-WBSystemStateRecovery [-BackupSet] <WBBackupSet> [[-TargetPath] <String>]
  [-AuthoritativeSysvolRecovery] [-RestartComputer] [-Async] [-Force] [<CommonParameters>]
- Start-WBSystemStateRecovery [-BackupSet] <WBBackupSet> [-ADIFM] [-TargetPath] <String>
  [-Async] [-Force] [<CommonParameters>]
options:
  -ADIFM Switch:
    required: true
  -Async Switch: ~
  -AuthoritativeSysvolRecovery Switch: ~
  -BackupSet WBBackupSet:
    required: true
  -Force Switch: ~
  -RestartComputer Switch: ~
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
