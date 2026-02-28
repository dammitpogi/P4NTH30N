description: Generates a package accelerator
synopses:
- New-AppvPackageAccelerator [-InputPackagePath] <String> [-Installer] <String> [-AcceleratorDescriptionFile
  <String>] [-Path] <String> [<CommonParameters>]
- New-AppvPackageAccelerator [-InputPackagePath] <String> [-InstalledFilesPath] <String>
  [-AcceleratorDescriptionFile <String>] [-Path] <String> [<CommonParameters>]
options:
  -AcceleratorDescriptionFile String: ~
  -InputPackagePath String:
    required: true
  -InstalledFilesPath String:
    required: true
  -Installer String:
    required: true
  -Path,-OutputPath String:
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
