description: Extracts the encrypted BitLocker recovery key from a shielded virtual
  machine's operating system disk
synopses:
- Save-ShieldedVMRecoveryKey -VHDPath <String> -Path <String> [-Force] [-WhatIf] [-Confirm]
- Save-ShieldedVMRecoveryKey -DiskNumber <Int32> -Path <String> [-Force] [-WhatIf]
  [-Confirm]
options:
  -DiskNumber Int32:
    required: true
  -Force Switch: ~
  -Path String:
    required: true
  -VHDPath String:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
