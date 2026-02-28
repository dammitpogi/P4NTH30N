description: Resets the resource utilization data collected by Hyper-V resource metering
synopses:
- Reset-VMResourceMetering [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String[]> [<CommonParameters>]
- Reset-VMResourceMetering [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-ResourcePoolName] <String> [[-ResourcePoolType]
  <VMResourcePoolType>] [<CommonParameters>]
- Reset-VMResourceMetering [-VM] <VirtualMachine[]> [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -ResourcePoolName,-Name String:
    required: true
  -ResourcePoolType VMResourcePoolType:
    values:
    - Ethernet
    - Memory
    - Processor
    - VHD
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
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
