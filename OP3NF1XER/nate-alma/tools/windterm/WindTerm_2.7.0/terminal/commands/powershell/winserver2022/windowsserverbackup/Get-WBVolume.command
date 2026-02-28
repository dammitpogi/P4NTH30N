description: Gets a list of volumes
synopses:
- Get-WBVolume [-Disk] <WBDisk> [-WhatIf] [-Confirm] [<CommonParameters>]
- Get-WBVolume [-Policy] <WBPolicy> [-WhatIf] [-Confirm] [<CommonParameters>]
- Get-WBVolume [-CriticalVolumes] [-WhatIf] [-Confirm] [<CommonParameters>]
- Get-WBVolume [-AllVolumes] [-WhatIf] [-Confirm] [<CommonParameters>]
- Get-WBVolume [-VolumePath] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllVolumes Switch:
    required: true
  -Confirm,-cf Switch: ~
  -CriticalVolumes Switch:
    required: true
  -Disk,-OnDisk WBDisk:
    required: true
  -Policy,-InPolicy WBPolicy:
    required: true
  -VolumePath String[]:
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
