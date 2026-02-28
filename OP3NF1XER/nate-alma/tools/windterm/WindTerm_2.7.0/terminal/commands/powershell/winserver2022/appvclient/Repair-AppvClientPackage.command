description: Resets the user settings of a package
synopses:
- Repair-AppvClientPackage [-Global] [-UserState] [-Extensions] [-PackageId] <Guid>
  [-VersionId] <Guid> [<CommonParameters>]
- Repair-AppvClientPackage [-Global] [-UserState] [-Extensions] [-Package] <AppvClientPackage>
  [<CommonParameters>]
- Repair-AppvClientPackage [-Global] [-UserState] [-Extensions] [-Name] <String> [[-Version]
  <String>] [<CommonParameters>]
options:
  -Extensions Switch: ~
  -Global Switch: ~
  -Name String:
    required: true
  -Package AppvClientPackage:
    required: true
  -PackageId Guid:
    required: true
  -UserState Switch: ~
  -Version String: ~
  -VersionId Guid:
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
