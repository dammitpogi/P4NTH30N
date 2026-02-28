description: Provisions a Shielded virtual machine
synopses:
- Initialize-ShieldedVM [-ShieldingDataFilePath] <String> [[-ShieldedVMSpecializationDataFilePath]
  <String>] [-VM] <VirtualMachine> [<CommonParameters>]
- Initialize-ShieldedVM [-ShieldingDataFilePath] <String> [[-ShieldedVMSpecializationDataFilePath]
  <String>] [-VMName] <String> [<CommonParameters>]
options:
  -ShieldedVMSpecializationDataFilePath String: ~
  -ShieldingDataFilePath String:
    required: true
  -VM VirtualMachine:
    required: true
  -VMName String:
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
