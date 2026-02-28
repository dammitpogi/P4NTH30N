description: Gets information about the installed provisioning package
synopses:
- Get-ProvisioningPackage [-PackageId] <String> [-LogsDirectoryPath <String>] [-WprpFile
  <String>] [-ConnectedDevice]
- Get-ProvisioningPackage [-PackagePath] <String> [-LogsDirectoryPath <String>] [-WprpFile
  <String>] [-ConnectedDevice]
- Get-ProvisioningPackage [-AllInstalledPackages] [-LogsDirectoryPath <String>] [-WprpFile
  <String>] [-ConnectedDevice]
options:
  -AllInstalledPackages,-All Switch: ~
  -ConnectedDevice,-Device Switch: ~
  -LogsDirectoryPath,-Logs String: ~
  -PackageId,-Id String:
    required: true
  -PackagePath,-Path String:
    required: true
  -WprpFile,-Wprp String: ~
