description: Queries the provisioning status of a shielded virtual machine
synopses:
- Get-ShieldedVMProvisioningStatus [-VMName] <String> [<CommonParameters>]
- Get-ShieldedVMProvisioningStatus [-VM] <VirtualMachine> [<CommonParameters>]
- Get-ShieldedVMProvisioningStatus -ProvisioningJob <CimInstance> [<CommonParameters>]
options:
  -ProvisioningJob CimInstance:
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
