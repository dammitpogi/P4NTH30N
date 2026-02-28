description: Mounts a previously created disk image (virtual hard disk or ISO), making
  it appear as a normal disk
synopses:
- Mount-DiskImage [-ImagePath] <String[]> [-StorageType <StorageType>] [-Access <Access>]
  [-NoDriveLetter] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Mount-DiskImage -InputObject <CimInstance[]> [-Access <Access>] [-NoDriveLetter]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Access Access:
    values:
    - Unknown
    - ReadWrite
    - ReadOnly
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ImagePath String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -NoDriveLetter Switch: ~
  -PassThru Switch: ~
  -StorageType StorageType:
    values:
    - Unknown
    - ISO
    - VHD
    - VHDX
    - VHDSet
  -ThrottleLimit Int32: ~
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
