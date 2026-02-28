description: Adds a virtual Fibre Channel host bus adapter to a virtual machine
synopses:
- Add-VMFibreChannelHba [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-SanName] <String> [-GenerateWwn] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMFibreChannelHba [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-SanName] <String> -WorldWideNodeNameSetA
  <String> -WorldWidePortNameSetA <String> -WorldWideNodeNameSetB <String> -WorldWidePortNameSetB
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMFibreChannelHba [-VM] <VirtualMachine[]> [-SanName] <String> [-GenerateWwn]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMFibreChannelHba [-VM] <VirtualMachine[]> [-SanName] <String> -WorldWideNodeNameSetA
  <String> -WorldWidePortNameSetA <String> -WorldWideNodeNameSetB <String> -WorldWidePortNameSetB
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -GenerateWwn Switch: ~
  -Passthru Switch: ~
  -SanName String:
    required: true
  -VM VirtualMachine[]:
    required: true
  -VMName String:
    required: true
  -WhatIf,-wi Switch: ~
  -WorldWideNodeNameSetA,-Wwnn1 String:
    required: true
  -WorldWideNodeNameSetB,-Wwnn2 String:
    required: true
  -WorldWidePortNameSetA,-Wwpn1 String:
    required: true
  -WorldWidePortNameSetB,-Wwpn2 String:
    required: true
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
