description: Creates a backup target object
synopses:
- New-WBBackupTarget [-Disk] <WBDisk> [[-Label] <String>] [[-PreserveExistingBackups]
  <Boolean>] [<CommonParameters>]
- New-WBBackupTarget [-Volume] <WBVolume> [<CommonParameters>]
- New-WBBackupTarget [-VolumePath] <String> [<CommonParameters>]
- New-WBBackupTarget [-NetworkPath] <String> [[-Credential] <PSCredential>] [-NonInheritAcl]
  [<CommonParameters>]
- New-WBBackupTarget [-RemovableDrive] <String> [<CommonParameters>]
options:
  -Credential PSCredential: ~
  -Disk WBDisk:
    required: true
  -Label String: ~
  -NetworkPath String:
    required: true
  -NonInheritAcl Switch: ~
  -PreserveExistingBackups Boolean: ~
  -RemovableDrive String:
    required: true
  -Volume WBVolume:
    required: true
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
