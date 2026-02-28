description: Configures an App-V Client Package
synopses:
- Set-AppvClientPackage [-Path <String>] [-DynamicDeploymentConfiguration <String>]
  [-UseNoConfiguration] [-PackageId] <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Set-AppvClientPackage [-Path <String>] [-DynamicDeploymentConfiguration <String>]
  [-UseNoConfiguration] [-Package] <AppvClientPackage> [<CommonParameters>]
- Set-AppvClientPackage [-Path <String>] [-DynamicDeploymentConfiguration <String>]
  [-UseNoConfiguration] [-Name] <String> [[-Version] <String>] [<CommonParameters>]
options:
  -DynamicDeploymentConfiguration String: ~
  -Name String:
    required: true
  -Package AppvClientPackage:
    required: true
  -PackageId Guid:
    required: true
  -Path,-PSPath String: ~
  -UseNoConfiguration Switch: ~
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
