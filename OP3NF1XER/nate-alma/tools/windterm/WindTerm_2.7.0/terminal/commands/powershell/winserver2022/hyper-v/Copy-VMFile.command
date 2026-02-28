description: Copies a file to a virtual machine
synopses:
- Copy-VMFile [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-SourcePath] <String> [-DestinationPath] <String>
  -FileSource <CopyFileSourceType> [-CreateFullPath] [-Force] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Copy-VMFile [-VM] <VirtualMachine[]> [-SourcePath] <String> [-DestinationPath] <String>
  -FileSource <CopyFileSourceType> [-CreateFullPath] [-Force] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -CreateFullPath Switch: ~
  -Credential PSCredential[]: ~
  -DestinationPath String:
    required: true
  -FileSource CopyFileSourceType:
    required: true
    values:
    - Host
  -Force Switch: ~
  -Name,-VMName String[]:
    required: true
  -SourcePath String:
    required: true
  -VM VirtualMachine[]:
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
