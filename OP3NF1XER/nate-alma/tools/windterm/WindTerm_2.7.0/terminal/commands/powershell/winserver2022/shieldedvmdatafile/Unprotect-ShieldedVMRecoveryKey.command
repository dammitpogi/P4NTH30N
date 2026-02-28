description: Decrypts an encrypted recovery key for a Windows shielded VM obtained
  from the [Save-ShieldedVMRecoveryKey](Save-ShieldedVMRecoveryKey.md) cmdlet
synopses:
- Unprotect-ShieldedVMRecoveryKey -ShieldingDataFilePath <String> -EncryptedBitLockerKeyPath
  <String> -DecryptedBitLockerKeyPath <String> [-WhatIf] [-Confirm]
- Unprotect-ShieldedVMRecoveryKey -ShieldingDataFileSearchPath <String[]> [-Recurse]
  -EncryptedBitLockerKeyPath <String> -DecryptedBitLockerKeyPath <String> [-WhatIf]
  [-Confirm]
options:
  -DecryptedBitLockerKeyPath String:
    required: true
  -EncryptedBitLockerKeyPath String:
    required: true
  -Recurse Switch: ~
  -ShieldingDataFilePath String:
    required: true
  -ShieldingDataFileSearchPath String[]:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
