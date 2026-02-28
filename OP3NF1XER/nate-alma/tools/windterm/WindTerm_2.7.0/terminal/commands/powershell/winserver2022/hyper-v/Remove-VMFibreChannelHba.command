description: Removes a Fibre Channel host bus adapter from a virtual machine
synopses:
- Remove-VMFibreChannelHba [-VMFibreChannelHba] <VMFibreChannelHba[]> [-Passthru]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMFibreChannelHba [-VMName] <String> [-WorldWideNodeNameSetA] <String> [-WorldWidePortNameSetA]
  <String> [-WorldWideNodeNameSetB] <String> [-WorldWidePortNameSetB] <String> [-Passthru]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -VMFibreChannelHba VMFibreChannelHba[]:
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
