description: Configures a key protector for a virtual machine
synopses:
- Set-VMKeyProtector [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-Passthru] [-KeyProtector <Byte[]>] [-NewLocalKeyProtector]
  [-RestoreLastKnownGoodKeyProtector] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMKeyProtector [-VM] <VirtualMachine[]> [-Passthru] [-KeyProtector <Byte[]>]
  [-NewLocalKeyProtector] [-RestoreLastKnownGoodKeyProtector] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -KeyProtector Byte[]: ~
  -NewLocalKeyProtector Switch: ~
  -Passthru Switch: ~
  -RestoreLastKnownGoodKeyProtector Switch: ~
  -VM VirtualMachine[]:
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
