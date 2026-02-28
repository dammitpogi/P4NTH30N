description: Gets the COM ports of a virtual machine or snapshot
synopses:
- Get-VMComPort [-VMName] <String[]> [[-Number] <Int32>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
- Get-VMComPort [-VM] <VirtualMachine[]> [[-Number] <Int32>] [<CommonParameters>]
- Get-VMComPort [-VMSnapshot] <VMSnapshot> [[-Number] <Int32>] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Number Int32: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMSnapshot,-VMCheckpoint VMSnapshot:
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
