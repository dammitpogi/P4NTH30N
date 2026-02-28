description: Configures the RemoteFX 3D video adapter of a virtual machine
synopses:
- Set-VMRemoteFx3dVideoAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String[]> [[-MonitorCount] <Byte>] [[-MaximumResolution]
  <String>] [[-VRAMSizeBytes] <UInt64>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMRemoteFx3dVideoAdapter [-VM] <VirtualMachine[]> [[-MonitorCount] <Byte>] [[-MaximumResolution]
  <String>] [[-VRAMSizeBytes] <UInt64>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMRemoteFx3dVideoAdapter [-VMRemoteFx3dVideoAdapter] <VMRemoteFx3DVideoAdapter[]>
  [[-MonitorCount] <Byte>] [[-MaximumResolution] <String>] [[-VRAMSizeBytes] <UInt64>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -MaximumResolution String: ~
  -MonitorCount Byte: ~
  -Passthru Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMRemoteFx3dVideoAdapter VMRemoteFx3DVideoAdapter[]:
    required: true
  -VRAMSizeBytes UInt64: ~
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
