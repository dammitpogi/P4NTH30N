description: Shuts down, turns off, or saves a virtual machine
synopses:
- Stop-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Name] <String[]> [-Save] [-TurnOff] [-Force] [-AsJob] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Stop-VM [-VM] <VirtualMachine[]> [-Save] [-TurnOff] [-Force] [-AsJob] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Force Switch: ~
  -Name,-VMName String[]:
    required: true
  -Passthru Switch: ~
  -Save Switch: ~
  -TurnOff Switch: ~
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
