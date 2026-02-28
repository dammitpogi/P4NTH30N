description: Install .PPKG package onto the local machine
synopses:
- Install-ProvisioningPackage [-PackagePath] <String> [-ForceInstall] [-QuietInstall]
  [-LogsDirectoryPath <String>] [-WprpFile <String>] [-ConnectedDevice] [<CommonParameters>]
options:
  -ConnectedDevice,-Device Switch: ~
  -ForceInstall,-Force Switch: ~
  -LogsDirectoryPath,-Logs String: ~
  -PackagePath,-Path String:
    required: true
  -QuietInstall,-Quiet Switch: ~
  -WprpFile,-Wprp String: ~
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
