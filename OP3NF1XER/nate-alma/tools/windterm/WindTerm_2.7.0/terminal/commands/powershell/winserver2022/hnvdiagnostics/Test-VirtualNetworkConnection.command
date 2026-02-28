description: Tests a virtual network connection
synopses:
- Test-VirtualNetworkConnection [-OperationId] <String> [[-HostName] <String>] [[-MgmtIp]
  <String>] [[-Creds] <PSCredential>] [[-VMName] <String>] [[-VMNetworkAdapterName]
  <String>] [[-VMNetworkAdapterProfileId] <String>] [-IsSender] <Boolean> [-SenderCAIP]
  <String> [-SenderVSID] <Int32> [-ListenerCAIP] <String> [-ListenerVSID] <Int32>
  [-SequenceNumber] <Int32> [[-PayloadSize] <Int32>] [<CommonParameters>]
options:
  -Creds PSCredential: ~
  -HostName String: ~
  -IsSender Boolean:
    required: true
  -ListenerCAIP String:
    required: true
  -ListenerVSID Int32:
    required: true
  -MgmtIp String: ~
  -OperationId String:
    required: true
  -PayloadSize Int32: ~
  -SenderCAIP String:
    required: true
  -SenderVSID Int32:
    required: true
  -SequenceNumber Int32:
    required: true
  -VMName String: ~
  -VMNetworkAdapterName String: ~
  -VMNetworkAdapterProfileId String: ~
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
