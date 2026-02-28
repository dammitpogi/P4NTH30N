description: Modifies an AD FS access control policy
synopses:
- Set-AdfsAccessControlPolicy [-Name <String>] [-Identifier <String>] [-Description
  <String>] [-PolicyMetadata <PolicyMetadata>] [-PolicyMetadataFile <String>] [-PassThru]
  [-TargetName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsAccessControlPolicy [-Name <String>] [-Identifier <String>] [-Description
  <String>] [-PolicyMetadata <PolicyMetadata>] [-PolicyMetadataFile <String>] [-PassThru]
  [-TargetIdentifier] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsAccessControlPolicy [-Name <String>] [-Identifier <String>] [-Description
  <String>] [-PolicyMetadata <PolicyMetadata>] [-PolicyMetadataFile <String>] [-PassThru]
  [-TargetAccessControlPolicy] <AdfsAccessControlPolicy> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Description String: ~
  -Identifier String: ~
  -Name String: ~
  -PassThru Switch: ~
  -PolicyMetadata PolicyMetadata: ~
  -PolicyMetadataFile String: ~
  -TargetAccessControlPolicy AdfsAccessControlPolicy:
    required: true
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
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
