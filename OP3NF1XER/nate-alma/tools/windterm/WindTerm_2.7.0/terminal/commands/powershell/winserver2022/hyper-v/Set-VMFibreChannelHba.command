description: Configures a Fibre Channel host bus adapter on a virtual machine
synopses:
- Set-VMFibreChannelHba [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-WorldWideNodeNameSetA] <String> [-WorldWidePortNameSetA]
  <String> [-WorldWideNodeNameSetB] <String> [-WorldWidePortNameSetB] <String> -SanName
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFibreChannelHba [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-WorldWideNodeNameSetA] <String> [-WorldWidePortNameSetA]
  <String> [-WorldWideNodeNameSetB] <String> [-WorldWidePortNameSetB] <String> [-GenerateWwn]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFibreChannelHba [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-WorldWideNodeNameSetA] <String> [-WorldWidePortNameSetA]
  <String> [-WorldWideNodeNameSetB] <String> [-WorldWidePortNameSetB] <String> [-NewWorldWideNodeNameSetA
  <String>] [-NewWorldWidePortNameSetA <String>] [-NewWorldWideNodeNameSetB <String>]
  [-NewWorldWidePortNameSetB <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFibreChannelHba [-VMFibreChannelHba] <VMFibreChannelHba> [-GenerateWwn] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFibreChannelHba [-VMFibreChannelHba] <VMFibreChannelHba> [-NewWorldWideNodeNameSetA
  <String>] [-NewWorldWidePortNameSetA <String>] [-NewWorldWideNodeNameSetB <String>]
  [-NewWorldWidePortNameSetB <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFibreChannelHba [-VMFibreChannelHba] <VMFibreChannelHba> -SanName <String>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -GenerateWwn Switch:
    required: true
  -NewWorldWideNodeNameSetA String: ~
  -NewWorldWideNodeNameSetB String: ~
  -NewWorldWidePortNameSetA String: ~
  -NewWorldWidePortNameSetB String: ~
  -Passthru Switch: ~
  -SanName String:
    required: true
  -VMFibreChannelHba VMFibreChannelHba:
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
