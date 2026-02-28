description: Returns App-V Client Packages
synopses:
- Get-AppvClientPackage [[-Name] <String>] [[-Version] <String>] [-All] [<CommonParameters>]
- Get-AppvClientPackage [-PackageId] <Guid> [[-VersionId] <Guid>] [-All] [<CommonParameters>]
options:
  -All Switch: ~
  -Name String: ~
  -PackageId Guid:
    required: true
  -Version String: ~
  -VersionId Guid: ~
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
