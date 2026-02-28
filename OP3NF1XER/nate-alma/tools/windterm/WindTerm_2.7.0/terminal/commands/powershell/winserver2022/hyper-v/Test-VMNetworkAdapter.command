description: Tests connectivity between virtual machines
synopses:
- Test-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-Name <String>] [-Sender] [-Receiver] -SenderIPAddress
  <String> -ReceiverIPAddress <String> [-NextHopMacAddress <String>] [-IsolationId
  <Int32>] -SequenceNumber <Int32> [-PayloadSize <Int32>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Test-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapter> [-Sender] [-Receiver]
  -SenderIPAddress <String> -ReceiverIPAddress <String> [-NextHopMacAddress <String>]
  [-IsolationId <Int32>] -SequenceNumber <Int32> [-PayloadSize <Int32>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Test-VMNetworkAdapter [-VM] <VirtualMachine> [-Name <String>] [-Sender] [-Receiver]
  -SenderIPAddress <String> -ReceiverIPAddress <String> [-NextHopMacAddress <String>]
  [-IsolationId <Int32>] -SequenceNumber <Int32> [-PayloadSize <Int32>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -IsolationId Int32: ~
  -Name,-VMNetworkAdapterName String: ~
  -NextHopMacAddress String: ~
  -Passthru Switch: ~
  -PayloadSize Int32: ~
  -Receiver Switch: ~
  -ReceiverIPAddress String:
    required: true
  -Sender Switch: ~
  -SenderIPAddress String:
    required: true
  -SequenceNumber Int32:
    required: true
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMNetworkAdapter VMNetworkAdapter:
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
