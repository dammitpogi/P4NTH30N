description: Debugs VMQ/VMMQ traffic
synopses:
- Debug-VirtualMachineQueueOperation [[-HostName] <String>] [[-MgmtIp] <String>] [[-Creds]
  <PSCredential>] [-VMName] <String> [-VMNetworkAdapterName] <String> [[-SampleCount]
  <UInt32>] [<CommonParameters>]
options:
  -Creds PSCredential: ~
  -HostName String: ~
  -MgmtIp String: ~
  -SampleCount UInt32: ~
  -VMName String:
    required: true
  -VMNetworkAdapterName String:
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
