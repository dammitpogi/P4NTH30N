description: Removes backups from a target catalog, a system catalog, or both
synopses:
- Remove-WBBackupSet [[-BackupSet] <WBBackupSet[]>] [[-KeepVersions] <Int32>] [-DeleteOldest]
  [[-MachineName] <String>] [-Force] [<CommonParameters>]
- Remove-WBBackupSet [[-BackupSet] <WBBackupSet[]>] [[-KeepVersions] <Int32>] [-DeleteOldest]
  [-BackupTarget] <WBBackupTarget> [[-MachineName] <String>] [-Force] [<CommonParameters>]
- Remove-WBBackupSet [[-BackupSet] <WBBackupSet[]>] [[-KeepVersions] <Int32>] [-DeleteOldest]
  [-VolumePath] <String> [[-MachineName] <String>] [-Force] [<CommonParameters>]
- Remove-WBBackupSet [[-BackupSet] <WBBackupSet[]>] [[-KeepVersions] <Int32>] [-DeleteOldest]
  [-NetworkPath] <String> [[-Credential] <PSCredential>] [-NonInheritAcl] [[-MachineName]
  <String>] [-Force] [<CommonParameters>]
options:
  -BackupSet WBBackupSet[]: ~
  -BackupTarget WBBackupTarget:
    required: true
  -Credential PSCredential: ~
  -DeleteOldest Switch: ~
  -Force Switch: ~
  -KeepVersions Int32: ~
  -MachineName String: ~
  -NetworkPath String:
    required: true
  -NonInheritAcl Switch: ~
  -VolumePath String:
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
