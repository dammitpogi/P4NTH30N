description: Creates a new App-V package
synopses:
- New-AppvSequencerPackage [-FullLoad] [-Installer] <String[]> [-InstallerOptions
  <String[]>] [[-PrimaryVirtualApplicationDirectory] <String>] [-Name] <String> [-Path]
  <String> [-TemplateFilePath <String>] [<CommonParameters>]
- New-AppvSequencerPackage [-AcceleratorFilePath] <String> [-InstallMediaPath] <String>
  [-Name] <String> [-Path] <String> [<CommonParameters>]
- New-AppvSequencerPackage [-AcceleratorFilePath] <String> [-InstalledFilesPath] <String>
  [-Name] <String> [-Path] <String> [<CommonParameters>]
options:
  -AcceleratorFilePath String:
    required: true
  -FullLoad Switch: ~
  -InstalledFilesPath String:
    required: true
  -Installer String[]:
    required: true
  -InstallerOptions String[]: ~
  -InstallMediaPath String:
    required: true
  -Name String:
    required: true
  -Path,-OutputPath String:
    required: true
  -PrimaryVirtualApplicationDirectory String: ~
  -TemplateFilePath String: ~
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
