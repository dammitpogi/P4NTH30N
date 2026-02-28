description: Configures settings for the virtual processors of a virtual machine.
  Settings are applied uniformly to all virtual processors belonging to the virtual
  machine
synopses:
- Set-VMProcessor [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-Count <Int64>] [-CompatibilityForMigrationEnabled
  <Boolean>] [-CompatibilityForOlderOperatingSystemsEnabled <Boolean>] [-HwThreadCountPerCore
  <Int64>] [-Maximum <Int64>] [-Reserve <Int64>] [-RelativeWeight <Int32>] [-MaximumCountPerNumaNode
  <Int32>] [-MaximumCountPerNumaSocket <Int32>] [-ResourcePoolName <String>] [-Perfmon
  <String>] [-EnableHostResourceProtection <Boolean>] [-ExposeVirtualizationExtensions
  <Boolean>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMProcessor [-VM] <VirtualMachine[]> [-Count <Int64>] [-CompatibilityForMigrationEnabled
  <Boolean>] [-CompatibilityForOlderOperatingSystemsEnabled <Boolean>] [-HwThreadCountPerCore
  <Int64>] [-Maximum <Int64>] [-Reserve <Int64>] [-RelativeWeight <Int32>] [-MaximumCountPerNumaNode
  <Int32>] [-MaximumCountPerNumaSocket <Int32>] [-ResourcePoolName <String>] [-EnableHostResourceProtection
  <Boolean>] [-ExposeVirtualizationExtensions <Boolean>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-VMProcessor [-VMProcessor] <VMProcessor[]> [-Count <Int64>] [-CompatibilityForMigrationEnabled
  <Boolean>] [-CompatibilityForOlderOperatingSystemsEnabled <Boolean>] [-HwThreadCountPerCore
  <Int64>] [-Maximum <Int64>] [-Reserve <Int64>] [-RelativeWeight <Int32>] [-MaximumCountPerNumaNode
  <Int32>] [-MaximumCountPerNumaSocket <Int32>] [-ResourcePoolName <String>] [-EnableHostResourceProtection
  <Boolean>] [-ExposeVirtualizationExtensions <Boolean>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -CompatibilityForMigrationEnabled Boolean: ~
  -CompatibilityForOlderOperatingSystemsEnabled Boolean: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Count Int64: ~
  -Credential PSCredential[]: ~
  -EnableHostResourceProtection Boolean: ~
  -ExposeVirtualizationExtensions Boolean: ~
  -HwThreadCountPerCore Int64: ~
  -Maximum Int64: ~
  -MaximumCountPerNumaNode Int32: ~
  -MaximumCountPerNumaSocket Int32: ~
  -Perfmon String: ~
  -Passthru Switch: ~
  -RelativeWeight Int32: ~
  -Reserve Int64: ~
  -ResourcePoolName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMProcessor VMProcessor[]:
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
