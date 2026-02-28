description: Sets properties associated with a virtual hard disk
synopses:
- Set-VHD [-Path] <String> [-ParentPath] <String> [-LeafPath <String>] [-IgnoreIdMismatch]
  [-Passthru] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VHD [-Path] <String> -PhysicalSectorSizeBytes <UInt32> [-Passthru] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VHD [-Path] <String> [-ResetDiskIdentifier] [-Force] [-Passthru] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Force Switch: ~
  -IgnoreIdMismatch Switch: ~
  -LeafPath String: ~
  -ParentPath String:
    required: true
  -Passthru Switch: ~
  -Path,-FullName String:
    required: true
  -PhysicalSectorSizeBytes UInt32:
    required: true
    values:
    - '512'
    - '4096'
  -ResetDiskIdentifier Switch:
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
