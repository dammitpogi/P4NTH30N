description: Removes the package from a computer
synopses:
- Remove-AppvClientPackage [-PackageId] <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Remove-AppvClientPackage [-Package] <AppvClientPackage> [<CommonParameters>]
- Remove-AppvClientPackage [-Name] <String> [[-Version] <String>] [<CommonParameters>]
options:
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
