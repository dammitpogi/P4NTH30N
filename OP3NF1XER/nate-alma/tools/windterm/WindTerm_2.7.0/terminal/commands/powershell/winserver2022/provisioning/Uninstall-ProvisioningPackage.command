description: Uninstalls .PPKG package from the local machine
synopses:
- Uninstall-ProvisioningPackage [-PackageId] <String> [-LogsDirectoryPath <String>]
  [-WprpFile <String>] [-ConnectedDevice]
- Uninstall-ProvisioningPackage -PackagePath <String> [-LogsDirectoryPath <String>]
  [-WprpFile <String>] [-ConnectedDevice]
- Uninstall-ProvisioningPackage [-AllInstalledPackages] [-LogsDirectoryPath <String>]
  [-WprpFile <String>] [-ConnectedDevice]
- Uninstall-ProvisioningPackage [-RuntimeMetadata] <RuntimeProvPackageMetadata> [-LogsDirectoryPath
  <String>] [-WprpFile <String>] [-ConnectedDevice]
options:
  -AllInstalledPackages,-All Switch:
    required: true
  -ConnectedDevice,-Device Switch: ~
  -LogsDirectoryPath,-Logs String: ~
  -PackageId,-Id String:
    required: true
  -PackagePath,-Path String:
    required: true
  -RuntimeMetadata RuntimeProvPackageMetadata:
    required: true
  -WprpFile,-Wprp String: ~
