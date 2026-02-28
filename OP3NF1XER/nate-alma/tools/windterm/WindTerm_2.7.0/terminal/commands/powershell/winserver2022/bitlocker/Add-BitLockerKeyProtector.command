description: Adds a key protector for a BitLocker volume
synopses:
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-PasswordProtector] [[-Password]
  <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-RecoveryPasswordProtector]
  [[-RecoveryPassword] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-StartupKeyProtector] [-StartupKeyPath]
  <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-StartupKeyPath] <String> [-TpmAndStartupKeyProtector]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-StartupKeyPath] <String> [-TpmAndPinAndStartupKeyProtector]
  [[-Pin] <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-ADAccountOrGroupProtector]
  [-ADAccountOrGroup] <String> [-Service] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [[-Pin] <SecureString>] [-TpmAndPinProtector]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-TpmProtector] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-BitLockerKeyProtector [-MountPoint] <String[]> [-RecoveryKeyProtector] [-RecoveryKeyPath]
  <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ADAccountOrGroup,-sid String:
    required: true
  -ADAccountOrGroupProtector,-sidp Switch:
    required: true
  -Confirm,-cf Switch: ~
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
