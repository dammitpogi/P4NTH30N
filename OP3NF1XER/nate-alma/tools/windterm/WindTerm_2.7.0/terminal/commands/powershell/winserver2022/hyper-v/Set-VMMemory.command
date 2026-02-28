description: Configures the memory of a virtual machine
synopses:
- Set-VMMemory [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-Buffer <Int32>] [-DynamicMemoryEnabled
  <Boolean>] [-MaximumBytes <Int64>] [-StartupBytes <Int64>] [-MinimumBytes <Int64>]
  [-Priority <Int32>] [-MaximumAmountPerNumaNodeBytes <Int64>] [-ResourcePoolName
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMMemory [-VM] <VirtualMachine[]> [-Buffer <Int32>] [-DynamicMemoryEnabled <Boolean>]
  [-MaximumBytes <Int64>] [-StartupBytes <Int64>] [-MinimumBytes <Int64>] [-Priority
  <Int32>] [-MaximumAmountPerNumaNodeBytes <Int64>] [-ResourcePoolName <String>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMMemory [-VMMemory] <VMMemory[]> [-Buffer <Int32>] [-DynamicMemoryEnabled <Boolean>]
  [-MaximumBytes <Int64>] [-StartupBytes <Int64>] [-MinimumBytes <Int64>] [-Priority
  <Int32>] [-MaximumAmountPerNumaNodeBytes <Int64>] [-ResourcePoolName <String>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Buffer Int32: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DynamicMemoryEnabled Boolean: ~
  -MaximumAmountPerNumaNodeBytes Int64: ~
  -MaximumBytes Int64: ~
  -MinimumBytes Int64: ~
  -Passthru Switch: ~
  -Priority Int32: ~
  -ResourcePoolName String: ~
  -StartupBytes Int64: ~
  -VM VirtualMachine[]:
    required: true
  -VMMemory VMMemory[]:
    required: true
  -VMName String[]:
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
