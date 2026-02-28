description: Authorizes a trusted code integrity policy to be used by hosts attesting
  against HGS
synopses:
- Add-HgsAttestationCIPolicy [-InputObject] <Byte[]> -Name <String> [-PolicyVersion
  <PolicyVersion>] [-Stage] [-WhatIf] [-Confirm]
- Add-HgsAttestationCIPolicy [-Path] <String> [-Name <String>] [-PolicyVersion <PolicyVersion>]
  [-Stage] [-WhatIf] [-Confirm]
options:
  -InputObject Byte[]:
    required: true
  -Name String:
    required: true
  -Path,-FilePath,-PSPath String:
    required: true
  -PolicyVersion PolicyVersion:
    values:
    - None
    - PolicyVersion1503
    - PolicyVersion1704
  -Stage Switch: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
