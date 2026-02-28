description: Adds an app package (.appx) that will install for each new user to a
  Windows image
synopses:
- Add-AppxProvisionedPackage [-FolderPath <String>] [-PackagePath <String>] [-DependencyPackagePath
  <String[]>] [-OptionalPackagePath <String[]>] [-LicensePath <String[]>] [-SkipLicense]
  [-CustomDataPath <String>] [-Regions <String>] [-StubPackageOption <StubPackageOption>]
  -Path <String> [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Add-AppxProvisionedPackage [-FolderPath <String>] [-PackagePath <String>] [-DependencyPackagePath
  <String[]>] [-OptionalPackagePath <String[]>] [-LicensePath <String[]>] [-SkipLicense]
  [-CustomDataPath <String>] [-Regions <String>] [-StubPackageOption <StubPackageOption>]
  [-Online] [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -CustomDataPath String: ~
  -DependencyPackagePath String[]: ~
  -FolderPath String: ~
  -LicensePath String[]: ~
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Online Switch:
    required: true
  -OptionalPackagePath String[]: ~
  -PackagePath String: ~
  -Path String:
    required: true
  -Regions String: ~
  -ScratchDirectory String: ~
  -SkipLicense Switch: ~
  -StubPackageOption StubPackageOption: ~
  -SystemDrive String: ~
  -WindowsDirectory String: ~
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
