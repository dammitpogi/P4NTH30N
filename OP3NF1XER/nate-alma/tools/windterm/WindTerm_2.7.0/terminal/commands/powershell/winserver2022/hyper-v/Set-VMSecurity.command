description: Configures security settings for a virtual machine
synopses:
- Set-VMSecurity [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-Passthru] [-EncryptStateAndVmMigrationTraffic
  <Boolean>] [-VirtualizationBasedSecurityOptOut <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMSecurity [-VM] <VirtualMachine[]> [-Passthru] [-EncryptStateAndVmMigrationTraffic
  <Boolean>] [-VirtualizationBasedSecurityOptOut <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -EncryptStateAndVmMigrationTraffic Boolean: ~
  -Passthru Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VirtualizationBasedSecurityOptOut Boolean: ~
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
