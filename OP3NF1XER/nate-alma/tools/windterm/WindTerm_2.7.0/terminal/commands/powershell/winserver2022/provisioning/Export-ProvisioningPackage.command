description: Extract the contents of a provisioning package
synopses:
- Export-ProvisioningPackage -PackageId <String> [-OutputFolder] <String> [-AllowClobber]
  [-AnswerFileOnly] [-LogsDirectoryPath <String>] [-WprpFile <String>] [-ConnectedDevice]
- Export-ProvisioningPackage [-PackagePath] <String> [-OutputFolder] <String> [-AllowClobber]
  [-AnswerFileOnly] [-LogsDirectoryPath <String>] [-WprpFile <String>] [-ConnectedDevice]
- Export-ProvisioningPackage [-RuntimeMetadata] <RuntimeProvPackageMetadata> [-OutputFolder]
  <String> [-AllowClobber] [-AnswerFileOnly] [-LogsDirectoryPath <String>] [-WprpFile
  <String>] [-ConnectedDevice]
options:
  -AllowClobber,-Force,-Overwrite Switch: ~
  -AnswerFileOnly Switch: ~
  -ConnectedDevice,-Device Switch: ~
  -LogsDirectoryPath,-Logs String: ~
  -OutputFolder,-Out String:
    required: true
  -PackageId,-Id String:
    required: true
  -PackagePath,-Path String:
    required: true
  -RuntimeMetadata RuntimeProvPackageMetadata:
    required: true
  -WprpFile,-Wprp String: ~
