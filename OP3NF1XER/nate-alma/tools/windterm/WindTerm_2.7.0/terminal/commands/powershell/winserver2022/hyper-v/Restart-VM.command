description: Restarts a virtual machine
synopses:
- Restart-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-Force] [-AsJob] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Restart-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-Name] <String[]> [-Force] [-AsJob] [-Passthru] [-Wait] [-For
  <WaitVMTypes>] [-Delay <UInt16>] [-Timeout <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Restart-VM [-VM] <VirtualMachine[]> [-Force] [-AsJob] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Restart-VM [-VM] <VirtualMachine[]> [-Force] [-AsJob] [-Passthru] [-Wait] [-For
  <WaitVMTypes>] [-Delay <UInt16>] [-Timeout <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Delay UInt16: ~
  -For WaitVMTypes:
    values:
    - Heartbeat
    - IPAddress
  -Force Switch: ~
  -Name,-VMName String[]:
    required: true
  -Passthru Switch: ~
  -Timeout,-TimeoutSec Int32: ~
  -VM VirtualMachine[]:
    required: true
  -Wait Switch:
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
