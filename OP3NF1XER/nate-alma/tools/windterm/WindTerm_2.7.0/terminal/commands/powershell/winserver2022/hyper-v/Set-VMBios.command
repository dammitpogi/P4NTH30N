description: Configures the BIOS of a Generation 1 virtual machine
synopses:
- Set-VMBios [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-DisableNumLock] [-EnableNumLock] [-StartupOrder
  <BootDevice[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMBios [-VM] <VirtualMachine[]> [-DisableNumLock] [-EnableNumLock] [-StartupOrder
  <BootDevice[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMBios [-VMBios] <VMBios[]> [-DisableNumLock] [-EnableNumLock] [-StartupOrder
  <BootDevice[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DisableNumLock Switch: ~
  -EnableNumLock Switch: ~
  -Passthru Switch: ~
  -StartupOrder BootDevice[]:
    values:
    - Floppy
    - CD
    - IDE
    - LegacyNetworkAdapter
    - NetworkAdapter
    - VHD
  -VM VirtualMachine[]:
    required: true
  -VMBios VMBios[]:
    required: true
  -VMName String[]:
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
