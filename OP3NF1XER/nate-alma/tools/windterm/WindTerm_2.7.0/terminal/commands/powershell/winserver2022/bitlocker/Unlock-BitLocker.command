description: Restores access to data on a BitLocker volume
synopses:
- Unlock-BitLocker [-MountPoint] <String[]> -Password <SecureString> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Unlock-BitLocker [-MountPoint] <String[]> -RecoveryPassword <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Unlock-BitLocker [-MountPoint] <String[]> -RecoveryKeyPath <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Unlock-BitLocker [-MountPoint] <String[]> [-AdAccountOrGroup] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AdAccountOrGroup Switch:
    required: true
  -Confirm,-cf Switch: ~
  -MountPoint String[]:
    required: true
  -Password,-pw SecureString:
    required: true
  -RecoveryKeyPath,-rk String:
    required: true
  -RecoveryPassword,-rp String:
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
