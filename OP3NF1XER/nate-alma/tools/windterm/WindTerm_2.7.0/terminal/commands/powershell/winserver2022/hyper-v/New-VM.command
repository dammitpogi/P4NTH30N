description: Creates a new virtual machine
synopses:
- New-VM [[-Name] <String>] [[-MemoryStartupBytes] <Int64>] [-BootDevice <BootDevice>]
  [-NoVHD] [-SwitchName <String>] [-Path <String>] [-Version <Version>] [-Prerelease]
  [-Experimental] [[-Generation] <Int16>] [-Force] [-AsJob] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-VM [[-Name] <String>] [[-MemoryStartupBytes] <Int64>] [-BootDevice <BootDevice>]
  [-SwitchName <String>] -NewVHDPath <String> -NewVHDSizeBytes <UInt64> [-Path <String>]
  [-Version <Version>] [-Prerelease] [-Experimental] [[-Generation] <Int16>] [-Force]
  [-AsJob] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-VM [[-Name] <String>] [[-MemoryStartupBytes] <Int64>] [-BootDevice <BootDevice>]
  [-SwitchName <String>] -VHDPath <String> [-Path <String>] [-Version <Version>] [-Prerelease]
  [-Experimental] [[-Generation] <Int16>] [-Force] [-AsJob] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BootDevice BootDevice:
    values:
    - Floppy
    - CD
    - IDE
    - LegacyNetworkAdapter
    - NetworkAdapter
    - VHD
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Experimental Switch: ~
  -Force Switch: ~
  -Generation Int16:
    values:
    - '1'
    - '2'
  -MemoryStartupBytes Int64: ~
  -Name,-VMName String: ~
  -NewVHDPath String:
    required: true
  -NewVHDSizeBytes UInt64:
    required: true
  -NoVHD Switch: ~
  -Path String: ~
  -Prerelease Switch: ~
  -SwitchName String: ~
  -VHDPath String:
    required: true
  -Version Version: ~
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
