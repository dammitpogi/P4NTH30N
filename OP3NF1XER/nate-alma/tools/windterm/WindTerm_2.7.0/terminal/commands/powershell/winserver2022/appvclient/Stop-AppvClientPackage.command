description: Shuts down virtual environments for specified packages
synopses:
- Stop-AppvClientPackage [-Global] [-PackageId] <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Stop-AppvClientPackage [-Global] [-Package] <AppvClientPackage> [<CommonParameters>]
- Stop-AppvClientPackage [-Global] [-Name] <String> [[-Version] <String>] [<CommonParameters>]
options:
  -Global Switch: ~
  -Name String:
    required: true
  -Package AppvClientPackage:
    required: true
  -PackageId Guid:
    required: true
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
