description: Publishes the App-V package
synopses:
- Publish-AppvClientPackage [-Global] [-UserSID <String>] [[-DynamicUserConfigurationPath]
  <String>] [-DynamicUserConfigurationType <DynamicUserConfiguration>] [-PackageId]
  <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Publish-AppvClientPackage [-Global] [-UserSID <String>] [[-DynamicUserConfigurationPath]
  <String>] [-DynamicUserConfigurationType <DynamicUserConfiguration>] [-Package]
  <AppvClientPackage> [<CommonParameters>]
- Publish-AppvClientPackage [-Global] [-UserSID <String>] [[-DynamicUserConfigurationPath]
  <String>] [-DynamicUserConfigurationType <DynamicUserConfiguration>] [-Name] <String>
  [[-Version] <String>] [<CommonParameters>]
options:
  -DynamicUserConfigurationPath String: ~
  -DynamicUserConfigurationType DynamicUserConfiguration:
    values:
    - UseDeploymentConfiguration
    - UseNoConfiguration
    - UseExistingConfiguration
  -Global Switch: ~
  -Name String:
    required: true
  -Package AppvClientPackage:
    required: true
  -PackageId Guid:
    required: true
  -UserSID String: ~
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
