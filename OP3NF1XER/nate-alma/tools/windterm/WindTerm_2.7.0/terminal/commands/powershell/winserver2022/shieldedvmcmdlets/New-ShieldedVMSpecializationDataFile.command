description: Creates a specialization data file to be used when provisioning a shielded
  virtual machine
synopses:
- New-ShieldedVMSpecializationDataFile [-ShieldedVMSpecializationDataFilePath] <String>
  [-SpecializationDataPairs] <Hashtable> [<CommonParameters>]
options:
  -ShieldedVMSpecializationDataFilePath String:
    required: true
  -SpecializationDataPairs Hashtable:
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
