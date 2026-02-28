description: Configures video settings for virtual machines
synopses:
- Set-VMVideo [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [[-ResolutionType] <ResolutionType>] [[-HorizontalResolution]
  <UInt16>] [[-VerticalResolution] <UInt16>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMVideo [-VM] <VirtualMachine[]> [[-ResolutionType] <ResolutionType>] [[-HorizontalResolution]
  <UInt16>] [[-VerticalResolution] <UInt16>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMVideo [-VMVideo] <VMVideo[]> [[-ResolutionType] <ResolutionType>] [[-HorizontalResolution]
  <UInt16>] [[-VerticalResolution] <UInt16>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -HorizontalResolution UInt16: ~
  -Passthru Switch: ~
  -ResolutionType ResolutionType:
    values:
    - Maximum
    - Single
    - Default
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMVideo VMVideo[]:
    required: true
  -VerticalResolution UInt16: ~
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
