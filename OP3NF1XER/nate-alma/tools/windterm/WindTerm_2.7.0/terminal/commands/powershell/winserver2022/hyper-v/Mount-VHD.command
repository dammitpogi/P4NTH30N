description: Mounts one or more virtual hard disks
synopses:
- Mount-VHD [-Path] <String[]> [-NoDriveLetter] [-ReadOnly] [-SnapshotId <Guid>] [-Passthru]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -NoDriveLetter Switch: ~
  -Passthru Switch: ~
  -Path,-FullName String[]:
    required: true
  -ReadOnly Switch: ~
  -SnapshotId Guid: ~
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
