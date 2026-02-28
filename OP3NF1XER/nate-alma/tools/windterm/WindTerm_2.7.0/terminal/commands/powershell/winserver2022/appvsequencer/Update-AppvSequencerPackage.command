description: Upgrades virtual application packages
synopses:
- Update-AppvSequencerPackage [-FullLoad] [-InputPackagePath] <String> [-Installer]
  <String[]> [-InstallerOptions <String[]>] [-Name] <String> [-Path] <String> [-TemplateFilePath
  <String>] [<CommonParameters>]
options:
  -FullLoad Switch: ~
  -InputPackagePath String:
    required: true
  -Installer String[]:
    required: true
  -InstallerOptions String[]: ~
  -Name String:
    required: true
  -Path,-OutputPath String:
    required: true
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
