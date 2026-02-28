description: Sets the description for a snapshot
synopses:
- Set-IscsiVirtualDiskSnapshot [-SnapshotId] <String> [-Description <String>] [-PassThru]
  [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Set-IscsiVirtualDiskSnapshot -InputObject <IscsiVirtualDiskSnapshot> [-Description
  <String>] [-PassThru] [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Credential PSCredential: ~
  -Description String: ~
  -InputObject IscsiVirtualDiskSnapshot:
    required: true
  -PassThru Switch: ~
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
