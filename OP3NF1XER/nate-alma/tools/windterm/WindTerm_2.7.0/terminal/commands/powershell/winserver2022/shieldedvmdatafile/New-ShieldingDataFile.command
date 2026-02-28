description: Creates a shielding data file
synopses:
- New-ShieldingDataFile [-ShieldingDataFilePath] <String> [-Owner] <Guardian> [-VolumeIDQualifier]
  <VolumeIDQualifier[]> [-AnswerFile] <NamedFileContent> [[-OtherFile] <NamedFileContent[]>]
  [[-Guardian] <Guardian[]>] [-Policy <FabricPolicyValue>] [-WhatIf] [-Confirm]
- New-ShieldingDataFile [-ShieldingDataFilePath] <String> [-Owner] <Guardian> [[-OtherFile]
  <NamedFileContent[]>] [[-Guardian] <Guardian[]>] [-Policy <FabricPolicyValue>] [-WhatIf]
  [-Confirm]
options:
  -AnswerFile,-WindowsUnattendFile NamedFileContent:
    required: true
  -Guardian Guardian[]: ~
  -OtherFile NamedFileContent[]: ~
  -Owner Guardian:
    required: true
  -Policy FabricPolicyValue:
    values:
    - Shielded
    - EncryptionSupported
  -ShieldingDataFilePath String:
    required: true
  -VolumeIDQualifier VolumeIDQualifier[]:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
