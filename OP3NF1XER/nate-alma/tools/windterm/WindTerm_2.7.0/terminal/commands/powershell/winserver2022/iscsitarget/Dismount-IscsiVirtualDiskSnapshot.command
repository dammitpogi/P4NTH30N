description: Dismounts the snapshot
synopses:
- Dismount-IscsiVirtualDiskSnapshot [-SnapshotId] <String> [-ComputerName <String>]
  [-Credential <PSCredential>] [<CommonParameters>]
- Dismount-IscsiVirtualDiskSnapshot -InputObject <IscsiVirtualDiskSnapshot> [-ComputerName
  <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -InputObject IscsiVirtualDiskSnapshot:
    required: true
  -SnapshotId String:
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
