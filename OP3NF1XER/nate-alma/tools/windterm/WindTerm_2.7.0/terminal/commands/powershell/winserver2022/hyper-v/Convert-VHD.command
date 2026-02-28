description: Converts the format, version type, and block size of a virtual hard disk
  file
synopses:
- Convert-VHD [-Path] <String> [-DestinationPath] <String> [-VHDType <VhdType>] [-ParentPath
  <String>] [-BlockSizeBytes <UInt32>] [-DeleteSource] [-AsJob] [-Passthru] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BlockSizeBytes UInt32: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DeleteSource Switch: ~
  -DestinationPath String:
    required: true
  -ParentPath String: ~
  -Passthru Switch: ~
  -Path,-FullName String:
    required: true
  -VHDType VhdType:
    values:
    - Unknown
    - Fixed
    - Dynamic
    - Differencing
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
