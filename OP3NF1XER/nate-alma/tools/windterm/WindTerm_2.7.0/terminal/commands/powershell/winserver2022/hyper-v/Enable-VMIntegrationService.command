description: Enables an integration service on a virtual machine
synopses:
- Enable-VMIntegrationService [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-Name] <String[]> [-VMName] <String[]> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-VMIntegrationService [-VMIntegrationService] <VMIntegrationComponent[]> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-VMIntegrationService [-Name] <String[]> [-VM] <VirtualMachine[]> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name String[]:
    required: true
  -Passthru Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMIntegrationService VMIntegrationComponent[]:
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
