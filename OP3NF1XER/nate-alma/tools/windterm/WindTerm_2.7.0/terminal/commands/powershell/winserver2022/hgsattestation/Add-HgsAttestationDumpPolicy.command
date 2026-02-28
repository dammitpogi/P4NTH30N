description: Adds an authorized dump encryption key to HGS
synopses:
- Add-HgsAttestationDumpPolicy [-PublicKeyHash] <String> -Name <String> [-PolicyVersion
  <PolicyVersion>] [-Stage] [-WhatIf] [-Confirm]
- Add-HgsAttestationDumpPolicy [-Path] <String> [-Name <String>] [-PolicyVersion <PolicyVersion>]
  [-Stage] [-WhatIf] [-Confirm]
options:
  -Name String:
    required: true
  -Path,-FilePath,-PSPath String:
    required: true
  -PolicyVersion PolicyVersion:
    values:
    - None
    - PolicyVersion1503
    - PolicyVersion1704
  -PublicKeyHash String:
    required: true
  -Stage Switch: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
