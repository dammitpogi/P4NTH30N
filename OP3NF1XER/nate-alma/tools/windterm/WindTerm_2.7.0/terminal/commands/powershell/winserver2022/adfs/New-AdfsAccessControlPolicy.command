description: Creates an AD FS access control policy
synopses:
- New-AdfsAccessControlPolicy -Name <String> [-SourceName <String>] [-Identifier <String>]
  [-Description <String>] [-PolicyMetadata <PolicyMetadata>] [-PolicyMetadataFile
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Description String: ~
  -Identifier String: ~
  -Name String:
    required: true
  -PolicyMetadata PolicyMetadata: ~
  -PolicyMetadataFile String: ~
  -SourceName String: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
