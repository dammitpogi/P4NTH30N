description: Enables BitLocker Drive Encryption for a volume
synopses:
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-PasswordProtector]
  [[-Password] <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-RecoveryPasswordProtector]
  [[-RecoveryPassword] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-StartupKeyProtector]
  [-StartupKeyPath] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-StartupKeyPath] <String>
  [-TpmAndStartupKeyProtector] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-StartupKeyPath] <String>
  [-TpmAndPinAndStartupKeyProtector] [[-Pin] <SecureString>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-AdAccountOrGroupProtector]
  [-Service] [-AdAccountOrGroup] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [[-Pin] <SecureString>]
  [-TpmAndPinProtector] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-TpmProtector] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Enable-BitLocker [-MountPoint] <String[]> [-EncryptionMethod <BitLockerVolumeEncryptionMethodOnEnable>]
  [-HardwareEncryption] [-SkipHardwareTest] [-UsedSpaceOnly] [-RecoveryKeyProtector]
  [-RecoveryKeyPath] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AdAccountOrGroup,-sid String:
    required: true
  -AdAccountOrGroupProtector,-sidp Switch:
    required: true
  -Confirm,-cf Switch: ~
  -EncryptionMethod BitLockerVolumeEncryptionMethodOnEnable:
    values:
    - Aes128
    - Aes256
    - XtsAes128
    - XtsAes256
  -HardwareEncryption Switch: ~
  -MountPoint String[]:
    required: true
  -Password,-pw SecureString: ~
  -PasswordProtector,-pwp Switch:
    required: true
  -Pin,-p SecureString: ~
  -RecoveryKeyPath,-rk String:
    required: true
  -RecoveryKeyProtector,-rkp Switch:
    required: true
  -RecoveryPassword,-rp String: ~
  -RecoveryPasswordProtector,-rpp Switch:
    required: true
  -Service Switch: ~
  -SkipHardwareTest,-s Switch: ~
  -StartupKeyPath,-sk String:
    required: true
  -StartupKeyProtector,-skp Switch:
    required: true
  -TpmAndPinAndStartupKeyProtector,-tpskp Switch:
    required: true
  -TpmAndPinProtector,-tpp Switch:
    required: true
  -TpmAndStartupKeyProtector,-tskp Switch:
    required: true
  -TpmProtector,-tpmp Switch:
    required: true
  -UsedSpaceOnly,-qe Switch: ~
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
